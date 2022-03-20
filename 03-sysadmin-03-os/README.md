# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`.

Посмотреть можно при помощи команды

`strace /bin/bash -c 'cd /tmp' 2>&1 | grep /tmp`
```
execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffde8409de0 /* 23 vars */) = 0
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
chdir("/tmp")
```

Первая строка срабатывает при fork, после чего выполняется exec. А третья строка как раз и делает необходимый нам системный вызов команды cd chdir("/tmp").


2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.

Можно глянуть какие файлы открываются при помощи команд
```
strace file /dev/tty 2>&1 | grep openat
strace file /dev/sda 2>&1 | grep openat
strace file /bin/bash 2>&1 | grep openat
```

А также глянуть о каких файлах и какая информация собирается
```
strace file /dev/tty 2>&1 | grep stat
strace file /dev/sda 2>&1 | grep stat
strace file /bin/bash 2>&1 | grep stat
```
Исходя из результатов можно сделать выводы
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3

База данных команды file - /usr/share/misc/magic.mgc

Так же ищет пользовательские файлы, по всей видимости

stat("/home/vagrant/.magic.mgc", 0x7ffedefbea50) = -1 ENOENT (No such file or directory)
stat("/home/vagrant/.magic", 0x7ffedefbea50) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
stat("/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3

3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

Создал файл через nano, наполнив данными
```
nano /tmp/do_not_delete_me
```

Запустил долгоиграющий скрипт
```
python3 -c "import time;f=open('/tmp/do_not_delete_me','r');time.sleep(600);" &
```

Убедился в том, что процесс использует этот файл, используя дескриптор 3
```
lsof -p 1799 | grep do_not_delete_me

python3 1799 vagrant    3r   REG  253,0        9 1572880 /tmp/do_not_delete_me
```

Далее удалил файл
```
rm /tmp/do_not_delete_me
```

Убедился в том, что процесс использует этот удаленный файл
```
lsof -p 1799 | grep do_not_delete_me

python3 1799 vagrant    3r   REG  253,0        9 1572880 /tmp/do_not_delete_me (deleted)
```

Воспользовался дескриптором 3, передав в него пустое значение, которым он и должен перезаписать файл
```
echo '' >/proc/1799/fd/3
```

Чтобы убедиться в том, что в файле после этого стало, я воссоздал файл снова, используя декриптор 3
```
cat /proc/1799/fd/3 > /tmp/do_not_delete_me
```

И глянул в него
```
cat /tmp/do_not_delete_me
```

Получил пустой файл

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

Родитель не смог обработать код возврата от дочернего процесса, но дочерний процесс завершился.
Следовательно, ресурсы этого процесса освобождены, но запись в таблице процессов остается. 
Запись освободиться при вызове wait() родительским процессом. 

5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

Установилось только таким образом, как написано в оф. доках
```
sudo apt-get install bpfcc-tools
which opensnoop-bpfcc
/usr/sbin/opensnoop-bpfcc
```

Далее запустил под root, иначе не работает и увидел список за первую секунду
```
sudo /usr/sbin/opensnoop-bpfcc

PID    COMM               FD ERR PATH
815    vminfo              5   0 /var/run/utmp
617    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
617    dbus-daemon        20   0 /usr/share/dbus-1/system-services
617    dbus-daemon        -1   2 /lib/dbus-1/system-services
617    dbus-daemon        20   0 /var/lib/snapd/dbus-1/system-services/
```

6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

Глянем на системный вызовы
```
strace -s 6500 uname -a
```

Там увидим 
```
uname({sysname="Linux", nodename="vagrant", ...}) = 0
```

Там увидим 
```
man 2 uname
39 строка NOTES
50 строка Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.
```

Проверим хотя бы одно значение
```
cat /proc/sys/kernel/ostype
Linux
```

7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?

&& - условный оператор

;  - разделитель последовательных команд
```
test -d /tmp/some_dir && echo Hi
```
в данном случае echo отработает только при успешном завершении команды test

Я так понял, что поведение оболочки по умолчанию заключается в игнорировании ошибок в сценариях.
Т.е. если ваш скрипт вызывает другие скрипты, то даже при возвратах ошибок других скриптов, он пробежится до самого конца, 
выполнив их все, и возвращая всё.

set -e останавливает выполнение сценария, если в команде или конвейере есть ошибка.
Т.е. происходит возврат сразу первой попавшейся ошибки.

В случае && вместе с set -e - не имеет смысла, так как при ошибке выполнении команд прекратится. 

8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?

 - e - останавливает выполнение сценария, если в команде или конвейере есть ошибка
 - x - вывод трейса простых команд 
 - u - неустановленные/не заданные параметры и переменные считаются как ошибки, с выводом в stderr текста ошибки и выполнит завершение не интерактивного вызова
 - o - pipefail возвращает код возврата набора/последовательности команд, ненулевой при последней команды или 0 для успешного выполнения команд.

Суть - повысить детализацию вывода ошибок (логирования), и завершить сценарий при наличии ошибок, на любом этапе выполнения сценария, кроме последней завершающей команды.


9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

Для упрощения подсчетов выполнил следующие команды, сортировка по алфавиту и количество уникальных совпадений
```
ps ax -o stat | sort | uniq -c

     8 I
     37 I<
      1 R+
     26 S
      2 S+
      7 S<
      1 Sl
      1 SLsl
      2 SN
      1 S<s
     13 Ss
      1 Ss+
      8 Ssl
      1 STAT
      1 T
```

Частота статусов процессов:
- S*(S, S+, S<, Sl, SLsl, SN, s<s, Ss, Ss+, Ssl) - Cпящие с прерыванием "сна"
- I*(I, I<) - фоновые, бездействующие процессы ядра

Дополнительные символы это дополнительные характеристики, например приоритет.