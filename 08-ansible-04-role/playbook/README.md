### Описание Play

Установка и настройка vector, lighthouse, clickhouse, используя роли:
- [vector-role](https://github.com/SomovAA/vector-role)
- [lighthouse-role](https://github.com/SomovAA/lighthouse-role)
- [ansible-clickhouse](https://github.com/alexeysetevoi/ansible-clickhouse)


## vector-role
### Параметры

- vector_dir - директория для файла rpm vector

### Теги

- vector - для работы с задачами по установке vector

### Установка Vector

- установка переменных (facts)
- создание директории для установочного файла
- загрузка установочного файла
- установка пакета
- старт сервиса


## lighthouse-role

### Параметры

- lighthouse_default_dir - директория по умолчанию для установки lighthouse, сейчас она должна совпадать с директорией по умолчанию для сайтов в nginx

### Теги

- lighthouse - для работы с задачами по установке lighthouse

### Установка Lighthouse

- установка пакетов git
- установка пакетов EPEL repo
- установка пакетов nginx
- старт сервиса nginx
- установка lighthouse
- рестарт сервиса nginx

### Требования

До использования роли должны быть установлены следующие пакеты:
- git
- nginx