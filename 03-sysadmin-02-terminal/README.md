# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"

1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.

Чтобы понять какие типы есть, и какой тип у cd, мы можем воспользоваться командой type

```
type -t cd
```
Команда cd - это оболочка, встроенная в Bash.

Изначально ход мыслей был таков: должно быть что-то такое, что очень тесно связано с ядром/оболочкой, 
что управляет/влияет на эту оболочку изначально, что она должна вместе с собой нам давать по-умолчанию.
Написав нечто подобное за её гранью, оно будет влиять не таким образом, т.к. либо нет возможности до чего-то добраться,
т.е. до внутренностей оболочки, либо это влияет на поведение, оно не будет таким, каким должно быть. Это лишь абстрактные мысли,
т.к. я не гуру linux, детального описания и под этот конкретный случай, сложно дать сходу.

Почитав мануал
http://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#What-is-a-shell_003f

Логично внутри сессии терминала работать с этим, нежели вне его.
Если мы будем работать внешней программой, то как добиваться того же?
Скорей всего каждый раз нужно будет создавать процессы, или новые сессии запускать для смены директории.

2. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`? `man grep` поможет в ответе на этот вопрос. Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.

Почитав мануалы обеих команд, стало понятно, что есть флаг у grep, который сделает точно такой же вывод

Проверил на схожем
```
man bash | grep -e "history" | wc -l
man bash | grep -с -e "history"
```

3. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

Посмотрел командой pstree -p

Увидел дерево, которое начинается с процесса PID = 1

systemd(1)─┬─VBoxService(810)─┬─{VBoxService}(812)
           │                  ├─{VBoxService}(813)
           │                  ├─{VBoxService}(814)
           │                  ├─{VBoxService}(815)
           │                  ├─{VBoxService}(816)
           │                  ├─{VBoxService}(817)
           │                  ├─{VBoxService}(818)
           │                  └─{VBoxService}(819)
           ├─accounts-daemon(611)─┬─{accounts-daemon}(623)

4. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?

Для начала откроем две сессии при помощи команд vagrant ssh, вызвав их в разных терминалах.

Убедимся, что у нас две сессии при помощи команды who
```
vagrant@vagrant:~$ who
vagrant  pts/0        2022-02-26 14:59 (10.0.2.2)
vagrant  pts/1        2022-02-26 15:57 (10.0.2.2)
```

В первом терминале вызвав tty мы получим /dev/pts/0, а во втором /dev/pts/1

Убедимся, что работает хотя бы stdout, попробуем из первого терминала передать во второй 
```
ls -l >/dev/pts/1
```

А теперь попробуем поискать по директории, которой не существует, чтобы ls кинул stderr, и перенаправим его
```
ls -l /fake 2>/dev/pts/1
```

5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.

Создадим файл 
```
echo 1234 > test.txt
```

Пробуем передать файл на stdin и вывести в stdout в другой файл.
```
cat < test.txt > test2.txt
```

6. Получится ли вывести находясь в графическом режиме данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

- Зашел в просмотр через эмулятор VM, переключился на необходимый контекст TTY, используя Ctrl+Alt+F3, ввел логин и пароль vagrant. Т.е. я в tty3, в этом легко убедиться, используя команду `tty` `/dev/tty3`
- Зашел в консоль через vagrant ssh. 
- Глянул через что я работаю, используя команду `tty` `/dev/pts/1`
- Далее перенаправил stdout из pts1 в tty3, `echo from pts1 to tty3 >/dev/tty3`
- Далее вернулся в графический режим, и увидел там это сообщение. Если бы он был не включен, то я увидел бы `-bash: /dev/tty3: Permission denied`

То же самое можно проделать и в обратную сторону
- Через графический режим, выполнив команду `echo from tty3 to pts1 >/dev/pts/1`
- Далее смотрим в консоли, и видим это сообщение, т.е. общаться можно в две стороны без проблем.

7. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?

Чтобы понять разницу, я выполнил команду `lsof -p $$` до команды `bash 5>&1` и после.
Получается она создала дескриптор под номером 5, и перенаправила его в stdout.
Т.е. мы при создании сразу сказали как работать с перенаправлением, потоком вывода.
Получается, если мы будем что-то направлять в 5, то это будет перенаправлено в 1, а это значит, 
что мы должны будем это видеть на экране, т.к. 1 является зарезервированным значением, 
и отвечает за вывод на экран.

Т.е. если выполнить команду `echo netology > /proc/$$/fd/5`, то мы увидим на экране netology

8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа.
Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.

Получается можно на лету создавать новый дескриптор под конкретным номером.
Ранее мы выводили в другой терминал сообщение об ошибке, а здесь получается его нужно вывести далее, и использовать

1) Мы должны новые дескриптор перенаправить в stderr
2) stderr перенаправить в stdout
3) stdout перенаправить в новый дескриптор

ls -l /fake 6>&2 2>&1 1>&6 | grep -c -e 'cannot access'

9. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?

Мы увидим переменные окружения, но есть команды для более простого обращения:
- printenv
- env
Вывод немного отличается, т.к. в printenv и env идет перенос каждой переменной окружения на новую строку
Если нужно точь-в-точь сделать, то можно сделать парсинг с заменой символов переноса.

10. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.

Для просмотра `man proc | grep -n -e '\/proc\/\[pid\]\/cmdline'` и `man proc | grep -n -e '\/proc\/\[pid\]\/exe'`

/proc/<PID>/cmdline - какой командой был запущен процесс [PID] (строка 172)
Например `cat /proc/$$/cmdline` получим `bash`

/proc/<PID>/exe - содержит ссылку на бинарный файл, который запущен в процессе [PID] (строка 212)
Чтобы посмотреть `ls -alh /proc/$$/exe` `lrwxrwxrwx 1 vagrant vagrant 0 Feb 27 09:42 /proc/5739/exe -> /usr/bin/bash`

11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.

cat /proc/cpuinfo | grep -e 'sse'

SSE 4.2

12. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:

    ```bash
	vagrant@netology1:~$ ssh localhost 'tty'
	not a tty
    ```

	Почитайте, почему так происходит, и как изменить поведение.

При подключении ожидается пользователь, а не другой процесс, и нет локального tty в данный момент. 
Для запуска можно добавить флаг -t, чтобы команда исполнялась c принудительным созданием псевдотерминала.
```bash
vagrant@vagrant:~$ ssh -t localhost 'tty'
vagrant@localhost's password: 
/dev/pts/3
Connection to localhost closed.
```

13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.

Установим `apt-get install reptyr`
Запустим пинг в фоновом процессе `ping ya.ru > 1.txt &`
Убедимся, что он там есть `ps -a` `7041 pts/0    00:00:00 ping`
При выполнении `reptyr 7041` получим ошибку о правах в `/proc/sys/kernel/yama/ptrace_scope` и `/etc/sysctl.d/10-ptrace.conf`
Выполним команду `echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope`
Выполним команду `nano /etc/sysctl.d/10-ptrace.conf` и заменим kernel.yama.ptrace_scope = 0
Далее перезапускаем машину, повторяем шаги вновь, чтобы pid найти для ping, он у меня стал 1325
Далее `sudo reptyr -T 1325`

14. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.

Команда tee делает вывод одновременно и в файл, указанный в качестве параметра, и в stdout, 
в данном примере команда получает вывод из stdin, перенаправленный через pipe от stdout команды echo
и так как команда запущена от sudo, соответственно имеет права на запись в файл