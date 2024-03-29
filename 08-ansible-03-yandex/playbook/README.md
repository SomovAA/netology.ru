### Описание Play

Установка и настройка vector, clickhouse и lighthouse на хостах, используя докер в локальной среде и yandex cloud для prod среды, запуск их служб.

### Параметры

- clickhouse_version - версия clickhouse
- clickhouse_packages - список пакетов clickhouse
- vector_arch - архитектура для версии vector
- vector_dir - директория для файла rpm vector
- lighthouse_default_dir - директория по умолчанию для установки lighthouse, сейчас она должна совпадать с директорией по умолчанию для сайтов в nginx

### Теги

- vector - для работы с задачами по установке vector
- clickhouse - для работы с задачами по установке clickhouse
- lighthouse - для работы с задачами по установке lighthouse

### Установка Vector

- установка переменных (facts)
- создание директории для установочного файла
- загрузка установочного файла
- установка пакета
- старт сервиса

### Установка Clickhouse

- загрузка установочных пакетов
- установка пакетов
- старт сервиса
- создание БД

### Установка Lighthouse

- установка пакетов git
- установка пакетов EPEL repo
- установка пакетов nginx
- старт сервиса nginx
- установка lighthouse
- рестарт сервиса nginx