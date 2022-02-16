# Домашнее задание к занятию «2.4. Инструменты Git»

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.


    aefead2207ef7e2aa5dc81a34aedf0cad4c32545 Update CHANGELOG.md

    git log --pretty=oneline aefea -1
    git log --pretty=format:"%H %s" aefea -1
    git show -q --pretty=oneline aefea
    git show -q --pretty=format:"%H %s" aefea

2. Какому тегу соответствует коммит `85024d3`?


    v0.12.23

    git describe --exact-match 85024d3
    git describe --tags 85024d3
    git tag --points-at 85024d3
3. Сколько родителей у коммита `b8d720`? Напишите их хеши.


    4703cb6c1c7a00137142da867588a5752c54fa6a

    git show 85024d3^
    git show 85024d3^1
    git show 85024d3~
    git show 85024d3~1

    Чтобы убедиться, что второго родителя нет git show 85024d3^2
4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами  v0.12.23 и v0.12.24.
5. Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит 
так `func providerSource(...)` (вместо троеточего перечислены аргументы).
6. Найдите все коммиты в которых была изменена функция `globalPluginDirs`.
7. Кто автор функции `synchronizedWriters`?