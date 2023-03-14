# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule: `pip3 install "molecule==3.5.2"`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos7` внутри корневой директории clickhouse-role, посмотрите на вывод команды.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 
5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

## Решение
- Ссылка на репозиторий с тестированной ролью https://github.com/SomovAA/vector-role;

В ней же есть Makefile для быстрой проверки задач локально.

### Результаты для molecule

Тестировал, используя образы pycontribs/centos:7, quay.io/centos/centos:stream8, debian:stretch

```
molecule test -s default
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/somov/.cache/ansible-compat/f5bcd7/modules:/home/somov/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/somov/.cache/ansible-compat/f5bcd7/collections:/home/somov/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/somov/.cache/ansible-compat/f5bcd7/roles:/home/somov/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /home/somov/.cache/ansible-compat/f5bcd7/roles/somovaa.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, dependency is disabled.
WARNING  Skipping, dependency is disabled.
INFO     Running default > lint
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos_7)
changed: [localhost] => (item=centos_8)
changed: [localhost] => (item=debian_stretch)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=centos_7)
ok: [localhost] => (item=centos_8)
ok: [localhost] => (item=debian_stretch)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/somov/PhpstormProjects/vector-role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'image': 'pycontribs/centos:7', 'name': 'centos_7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
ok: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/sbin/init', 'image': 'quay.io/centos/centos:stream8', 'name': 'centos_8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
ok: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/sbin/init', 'dockerfile': 'Dockerfile', 'image': 'debian:stretch', 'name': 'debian_stretch', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})

TASK [Create Dockerfiles from image names] *************************************
changed: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'image': 'pycontribs/centos:7', 'name': 'centos_7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
changed: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/sbin/init', 'image': 'quay.io/centos/centos:stream8', 'name': 'centos_8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
changed: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/sbin/init', 'dockerfile': 'Dockerfile', 'image': 'debian:stretch', 'name': 'debian_stretch', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})

TASK [Synchronization the context] *********************************************
changed: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'image': 'pycontribs/centos:7', 'name': 'centos_7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
ok: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/sbin/init', 'image': 'quay.io/centos/centos:stream8', 'name': 'centos_8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
changed: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/sbin/init', 'dockerfile': 'Dockerfile', 'image': 'debian:stretch', 'name': 'debian_stretch', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item=None)
ok: [localhost] => (item=None)
ok: [localhost] => (item=None)
ok: [localhost]

TASK [Build an Ansible compatible image (new)] *********************************
ok: [localhost] => (item=molecule_local/pycontribs/centos:7)
ok: [localhost] => (item=molecule_local/quay.io/centos/centos:stream8)
ok: [localhost] => (item=molecule_local/debian:stretch)

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item=None)
ok: [localhost] => (item=None)
ok: [localhost] => (item=None)
ok: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos_7)
changed: [localhost] => (item=centos_8)
changed: [localhost] => (item=debian_stretch)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=None)
changed: [localhost] => (item=None)
changed: [localhost] => (item=None)
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=9    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos_8]
ok: [debian_stretch]
ok: [centos_7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Create a directory] ****************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/tmp/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [debian_stretch]
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/tmp/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [centos_7]
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/tmp/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [centos_8]

TASK [vector-role : Download for apt] ******************************************
skipping: [centos_7]
skipping: [centos_8]
changed: [debian_stretch]

TASK [vector-role : Install vector for apt] ************************************
skipping: [centos_7]
skipping: [centos_8]
Selecting previously unselected package vector.
(Reading database ... 13025 files and directories currently installed.)
Preparing to unpack .../vector_0.27.0-1.amd64.deb ...
Unpacking vector (0.27.0-1) ...
Setting up vector (0.27.0-1) ...
systemd-journal:x:101:
changed: [debian_stretch]

TASK [vector-role : Download for yum] ******************************************
skipping: [centos_8]
skipping: [debian_stretch]
changed: [centos_7]

TASK [vector-role : Install package for yum] ***********************************
skipping: [centos_8]
skipping: [debian_stretch]
changed: [centos_7]

TASK [vector-role : Download for dnf] ******************************************
skipping: [centos_7]
skipping: [debian_stretch]
changed: [centos_8]

TASK [vector-role : Install package for dnf] ***********************************
skipping: [centos_7]
skipping: [debian_stretch]
changed: [centos_8]

TASK [vector-role : Start vector service] **************************************
changed: [debian_stretch]
changed: [centos_8]
changed: [centos_7]

PLAY RECAP *********************************************************************
centos_7                   : ok=5    changed=4    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
centos_8                   : ok=5    changed=4    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
debian_stretch             : ok=5    changed=4    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [debian_stretch]
ok: [centos_8]
ok: [centos_7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Create a directory] ****************************************
ok: [debian_stretch]
ok: [centos_7]
ok: [centos_8]

TASK [vector-role : Download for apt] ******************************************
skipping: [centos_7]
skipping: [centos_8]
ok: [debian_stretch]

TASK [vector-role : Install vector for apt] ************************************
skipping: [centos_7]
skipping: [centos_8]
ok: [debian_stretch]

TASK [vector-role : Download for yum] ******************************************
skipping: [centos_8]
skipping: [debian_stretch]
ok: [centos_7]

TASK [vector-role : Install package for yum] ***********************************
skipping: [centos_8]
skipping: [debian_stretch]
ok: [centos_7]

TASK [vector-role : Download for dnf] ******************************************
skipping: [centos_7]
skipping: [debian_stretch]
ok: [centos_8]

TASK [vector-role : Install package for dnf] ***********************************
skipping: [centos_7]
skipping: [debian_stretch]
ok: [centos_8]

TASK [vector-role : Start vector service] **************************************
ok: [debian_stretch]
ok: [centos_8]
ok: [centos_7]

PLAY RECAP *********************************************************************
centos_7                   : ok=5    changed=0    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
centos_8                   : ok=5    changed=0    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
debian_stretch             : ok=5    changed=0    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Gather Local Services] ***************************************************
ok: [debian_stretch]
ok: [centos_8]
ok: [centos_7]

TASK [Assert Vector Service] ***************************************************
ok: [centos_7] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [centos_8] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [debian_stretch] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Gather Installed Packages] ***********************************************
ok: [centos_7]
ok: [centos_8]
ok: [debian_stretch]

TASK [Assert Vector Package] ***************************************************
ok: [centos_7] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [centos_8] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [debian_stretch] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos_7                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
centos_8                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
debian_stretch             : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos_7)
changed: [localhost] => (item=centos_8)
changed: [localhost] => (item=debian_stretch)

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item=centos_7)
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos_8)
changed: [localhost] => (item=debian_stretch)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```

### Результаты для tox

Тестировал, используя образ pycontribs/centos:7

```
docker exec -it aragast sh -c 'tox'
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.1,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.1.0,click==8.1.3,click-help-colors==0.9.1,colorama==0.4.6,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==39.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.0.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.2,MarkupSafe==2.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.28.2,rich==10.16.2,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.5.0,urllib3==1.26.15,wcmatch==8.4.1,yamllint==1.29.0,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='2724257053'
py37-ansible210 run-test: commands[0] | molecule test -s podman --destroy always
INFO     podman scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/somovaa.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running podman > dependency
INFO     Running ansible-galaxy collection install -v containers.podman:>=1.7.0
INFO     Running ansible-galaxy collection install -v ansible.posix:>=1.3.0
WARNING  Skipping, dependency is disabled.
WARNING  Skipping, dependency is disabled.
INFO     Running podman > lint
COMMAND: ansible-lint
yamllint .

Loading custom .yamllint config file, this extends our internal yamllint config.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'image': 'pycontribs/centos:7', 'name': 'centos_7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '864113486256.159', 'results_file': '/root/.ansible_async/864113486256.159', 'changed': True, 'failed': False, 'item': {'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'image': 'pycontribs/centos:7', 'name': 'centos_7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running podman > syntax

playbook: /opt/vector-role/molecule/podman/converge.yml
INFO     Running podman > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="centos_7 registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
changed: [localhost] => (item="Dockerfile: None specified; Image: pycontribs/centos:7")

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=centos_7)

TASK [Build an Ansible compatible image] ***************************************
changed: [localhost] => (item=pycontribs/centos:7)

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="centos_7 command: /usr/sbin/init")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=centos_7: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos_7)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=centos_7)

PLAY RECAP *********************************************************************
localhost                  : ok=10   changed=5    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

INFO     Running podman > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running podman > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos_7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Create a directory] ****************************************
changed: [centos_7]

TASK [vector-role : Download for apt] ******************************************
skipping: [centos_7]

TASK [vector-role : Install vector for apt] ************************************
skipping: [centos_7]

TASK [vector-role : Download for yum] ******************************************
changed: [centos_7]

TASK [vector-role : Install package for yum] ***********************************
changed: [centos_7]

TASK [vector-role : Download for dnf] ******************************************
skipping: [centos_7]

TASK [vector-role : Install package for dnf] ***********************************
skipping: [centos_7]

TASK [vector-role : Start vector service] **************************************
changed: [centos_7]

PLAY RECAP *********************************************************************
centos_7                   : ok=5    changed=4    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running podman > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos_7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Create a directory] ****************************************
ok: [centos_7]

TASK [vector-role : Download for apt] ******************************************
skipping: [centos_7]

TASK [vector-role : Install vector for apt] ************************************
skipping: [centos_7]

TASK [vector-role : Download for yum] ******************************************
ok: [centos_7]

TASK [vector-role : Install package for yum] ***********************************
ok: [centos_7]

TASK [vector-role : Download for dnf] ******************************************
skipping: [centos_7]

TASK [vector-role : Install package for dnf] ***********************************
skipping: [centos_7]

TASK [vector-role : Start vector service] **************************************
ok: [centos_7]

PLAY RECAP *********************************************************************
centos_7                   : ok=5    changed=0    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running podman > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running podman > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
ok: [centos_7] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos_7                   : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'image': 'pycontribs/centos:7', 'name': 'centos_7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '194903438345.3913', 'results_file': '/root/.ansible_async/194903438345.3913', 'changed': True, 'failed': False, 'item': {'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'image': 'pycontribs/centos:7', 'name': 'centos_7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
___________________________________ summary ____________________________________
  py37-ansible210: commands succeeded
  congratulations :)
```