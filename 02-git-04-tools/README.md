# Домашнее задание к занятию «2.4. Инструменты Git»

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.

`aefead2207ef7e2aa5dc81a34aedf0cad4c32545 Update CHANGELOG.md`

- git log --pretty=oneline aefea -1
- git log --pretty=format:"%H %s" aefea -1 
- git show -q --pretty=oneline aefea
- git show -q --pretty=format:"%H %s" aefea

2. Какому тегу соответствует коммит `85024d3`?

`v0.12.23`

- git describe --exact-match 85024d3
- git describe --tags 85024d3
- git tag --points-at 85024d3

3. Сколько родителей у коммита `b8d720`? Напишите их хеши.

`56cd7859e05c36c06b56d013b55a252d0bb7e158`
`9ea88f22fc6269854151c571162c5bcf958bee2b`

- git show b8d720^
- git show b8d720^1
- git show b8d720~
- git show b8d720~1
- git show b8d720^2
- git show b8d720~2

4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами  v0.12.23 и v0.12.24.

- `b14b74c49 [Website] vmc provider links`
- `3f235065b Update CHANGELOG.md`
- `6ae64e247 registry: Fix panic when server is unreachable`
- `5c619ca1b website: Remove links to the getting started guide's old location`
- `06275647e Update CHANGELOG.md`
- `d5f9411f5 command: Fix bug when using terraform login on Windows`
- `4b6d06cc5 Update CHANGELOG.md`
- `dd01a3507 Update CHANGELOG.md`
- `225466bc3 Cleanup after v0.12.23 release`


- git log --oneline v0.12.23..v0.12.24 --skip=1

5. Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит 
так `func providerSource(...)` (вместо троеточего перечислены аргументы).

`8c928e835`

- git log --pretty=format:'%h' --reverse -S 'func providerSource' | head -1

6. Найдите все коммиты в которых была изменена функция `globalPluginDirs`.

`8364383c3`

Эта команда показывает один коммит
- git log --pretty=format:'%h' -S 'func globalPluginDirs'


- `78b122055`
- `52dbf9483`
- `41ab0aef7`
- `66ebff90c`
- `8364383c3`
    
А эта множество

По отдельности
- git grep --name-only 'func globalPluginDirs'
- git log --no-patch --pretty=format:"%h" -L ":func globalPluginDirs:plugins.go"

Автоматизировал
- file=$(git grep --name-only 'func globalPluginDirs') && git log --pretty=format:"%h" --no-patch -L ":func globalPluginDirs:$file"

7. Кто автор функции `synchronizedWriters`?

`Martin Atkins`

- commit=$(git log --pretty=format:'%H' --reverse  -S 'synchronizedWriters' | head -1) && git show $commit --pretty=format:'%an' -q