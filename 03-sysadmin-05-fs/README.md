# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

Последовательности нулевых байтов заменены на информацию об этих последовательностях.
Последовательности не записаны на диск. Информация о них хранится в метаданных ФС.
Следовательно, файлы вешают меньше, требуется меньше времени на запись, диск дольше живет.

Удобно хранить бэкап. Либо использовать ПО такое, которое получает данные, и хранит в таком виде, пока не требуется полный исходник, например торрент.

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Об этом говорилось на лекции, также и были продемонстрированы примеры. Повторим это сами, чтобы убедиться

```
touch test_one
stat test_one | grep -E "Inode|Gid"
Device: fd00h/64768d    Inode: 1052844     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)

ln test_one test_two

stat test_one | grep -E "Inode|Gid"
Device: fd00h/64768d    Inode: 1052844     Links: 2
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)

stat test_two | grep -E "Inode|Gid"
Device: fd00h/64768d    Inode: 1052844     Links: 2
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)

chmod 0666 test_one

stat test_one | grep -E "Inode|Gid"
Device: fd00h/64768d    Inode: 1052844     Links: 2
Access: (0666/-rw-rw-rw-)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)

stat test_two | grep -E "Inode|Gid"
Device: fd00h/64768d    Inode: 1052844     Links: 2
Access: (0666/-rw-rw-rw-)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)
```

Hardlink это жесткая ссылка на файл, имеет тот же inode, права будут одинаковые, изменения 
таким образом одного файла, затронут другой. А разница в названиях хранится в структуре директорий.

3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

Посмотрим как это в системе выглядит
```
lsblk -p
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
/dev/sda                                8:0    0   64G  0 disk
├─/dev/sda1                             8:1    0    1M  0 part
├─/dev/sda2                             8:2    0    1G  0 part /boot
└─/dev/sda3                             8:3    0   63G  0 part
  └─/dev/mapper/ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
/dev/sdb                                8:16   0  2.5G  0 disk
/dev/sdc                                8:32   0  2.5G  0 disk
```

4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

Попадем в интерактивный режим для /dev/sdb, и глянем опции для работы с ним
```
sudo fdisk /dev/sdb

Command (m for help): m

Help:
  GPT
   M   enter protective/hybrid MBR

  Generic
   d   delete a partition
   F   list free unpartitioned space
   l   list known partition types
   n   add a new partition
   p   print the partition table
   t   change a partition type
   v   verify the partition table
   i   print information about a partition

  Misc
   m   print this menu
   x   extra functionality (experts only)

  Script
   I   load disk layout from sfdisk script file
   O   dump disk layout to sfdisk script file

  Save & Exit
   w   write table to disk and exit
   q   quit without saving changes

  Create a new label
   g   create a new empty GPT partition table
   G   create a new empty SGI (IRIX) partition table
   o   create a new empty DOS partition table
   s   create a new empty Sun partition table
```

Создадим таблицу разделов GPT
```
Command (m for help): g
Created a new GPT disklabel (GUID: 10265E75-DB82-6D4C-80B1-891EDBAAB875).
```

Создадим раздел с 2 ГБ
```
Command (m for help): n 
Partition number (1-128, default 1): 1
First sector (2048-5242846, default 2048): 2048
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242846, default 5242846): +2G

Created a new partition 1 of type 'Linux filesystem' and of size 2 GiB.
```

Создадим раздел с оставшимся местом
```
Command (m for help): n
Partition number (2-128, default 2): 2
First sector (4196352-5242846, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242846, default 5242846):

Created a new partition 2 of type 'Linux filesystem' and of size 511 MiB.
```

Применим изменения
```
Command (m for help): w

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

Посмотрим как теперь это в системе выглядит
```
lsblk -p
NAME                                  MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
/dev/sda                                8:0    0   64G  0 disk
├─/dev/sda1                             8:1    0    1M  0 part
├─/dev/sda2                             8:2    0    1G  0 part /boot
└─/dev/sda3                             8:3    0   63G  0 part
  └─/dev/mapper/ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
/dev/sdb                                8:16   0  2.5G  0 disk
├─/dev/sdb1                             8:17   0    2G  0 part
└─/dev/sdb2                             8:18   0  511M  0 part
/dev/sdc                                8:32   0  2.5G  0 disk
```

5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

Нам нужно сделать дамп, и как говорилось в лекции, сразу же его перенаправить
```
sudo sfdisk --dump /dev/sdb | sudo sfdisk --force /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new GPT disklabel (GUID: 10265E75-DB82-6D4C-80B1-891EDBAAB875).
/dev/sdc1: Created a new partition 1 of type 'Linux filesystem' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux filesystem' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: gpt
Disk identifier: 10265E75-DB82-6D4C-80B1-891EDBAAB875

Device       Start     End Sectors  Size Type
/dev/sdc1     2048 4196351 4194304    2G Linux filesystem
/dev/sdc2  4196352 5242846 1046495  511M Linux filesystem

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

Посмотрим как это в системе выглядит
```
lsblk -p
NAME                                  MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
/dev/sda                                8:0    0   64G  0 disk
├─/dev/sda1                             8:1    0    1M  0 part
├─/dev/sda2                             8:2    0    1G  0 part /boot
└─/dev/sda3                             8:3    0   63G  0 part
  └─/dev/mapper/ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
/dev/sdb                                8:16   0  2.5G  0 disk
├─/dev/sdb1                             8:17   0    2G  0 part
└─/dev/sdb2                             8:18   0  511M  0 part
/dev/sdc                                8:32   0  2.5G  0 disk
├─/dev/sdc1                             8:33   0    2G  0 part
└─/dev/sdc2                             8:34   0  511M  0 part
```

6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

```
sudo mdadm --create --verbose /dev/md1 --level=1 --raid-devices=2 /dev/sd{b1,c1}
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array?
Continue creating array? (y/n) y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
```

Посмотрим как это в системе выглядит
```
lsblk -p
NAME                                  MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
/dev/sda                                8:0    0   64G  0 disk
├─/dev/sda1                             8:1    0    1M  0 part
├─/dev/sda2                             8:2    0    1G  0 part  /boot
└─/dev/sda3                             8:3    0   63G  0 part
  └─/dev/mapper/ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
/dev/sdb                                8:16   0  2.5G  0 disk
├─/dev/sdb1                             8:17   0    2G  0 part
│ └─/dev/md1                            9:1    0    2G  0 raid1
└─/dev/sdb2                             8:18   0  511M  0 part
/dev/sdc                                8:32   0  2.5G  0 disk
├─/dev/sdc1                             8:33   0    2G  0 part
│ └─/dev/md1                            9:1    0    2G  0 raid1
└─/dev/sdc2                             8:34   0  511M  0 part
```

```
cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md1 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]

unused devices: <none>
```

7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.
```
sudo mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 /dev/sd{b2,c2}
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
```
```
lsblk -p
NAME                                  MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
/dev/sda                                8:0    0   64G  0 disk
├─/dev/sda1                             8:1    0    1M  0 part
├─/dev/sda2                             8:2    0    1G  0 part  /boot
└─/dev/sda3                             8:3    0   63G  0 part
  └─/dev/mapper/ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
/dev/sdb                                8:16   0  2.5G  0 disk
├─/dev/sdb1                             8:17   0    2G  0 part
│ └─/dev/md1                            9:1    0    2G  0 raid1
└─/dev/sdb2                             8:18   0  511M  0 part
  └─/dev/md0                            9:0    0 1017M  0 raid0
/dev/sdc                                8:32   0  2.5G  0 disk
├─/dev/sdc1                             8:33   0    2G  0 part
│ └─/dev/md1                            9:1    0    2G  0 raid1
└─/dev/sdc2                             8:34   0  511M  0 part
  └─/dev/md0                            9:0    0 1017M  0 raid0
```
```
cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid0 sdc2[1] sdb2[0]
      1041408 blocks super 1.2 512k chunks

md1 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]

unused devices: <none>
```

8. Создайте 2 независимых PV на получившихся md-устройствах.
```
sudo pvcreate /dev/md1 /dev/md0
  Physical volume "/dev/md1" successfully created.
  Physical volume "/dev/md0" successfully created.
```
```
sudo pvs
  PV         VG        Fmt  Attr PSize    PFree   
  /dev/md0             lvm2 ---  1017.00m 1017.00m
  /dev/md1             lvm2 ---    <2.00g   <2.00g
  /dev/sda3  ubuntu-vg lvm2 a--   <63.00g  <31.50g
```

9. Создайте общую volume-group на этих двух PV.

```
sudo vgcreate vg1 /dev/md1 /dev/md0
  Volume group "vg1" successfully created
```
```
sudo vgs
  VG        #PV #LV #SN Attr   VSize   VFree  
  ubuntu-vg   1   1   0 wz--n- <63.00g <31.50g
  vg1         2   0   0 wz--n-  <2.99g  <2.99g
```
```
sudo vgdisplay
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <63.00 GiB
  PE Size               4.00 MiB
  Total PE              16127
  Alloc PE / Size       8064 / 31.50 GiB
  Free  PE / Size       8063 / <31.50 GiB
  VG UUID               aK7Bd1-JPle-i0h7-5jJa-M60v-WwMk-PFByJ7

  --- Volume group ---
  VG Name               vg1
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <2.99 GiB
  PE Size               4.00 MiB
  Total PE              765
  Alloc PE / Size       0 / 0
  Free  PE / Size       765 / <2.99 GiB
  VG UUID               1GJwW6-ix4q-c6BK-txcT-sUz6-ZwBG-Yk1MVi
```

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
```
sudo lvcreate -L 100M vg1 /dev/md0
  Logical volume "lvol0" created.
```
```
lsblk -p
NAME                                  MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
/dev/sda                                8:0    0   64G  0 disk
├─/dev/sda1                             8:1    0    1M  0 part
├─/dev/sda2                             8:2    0    1G  0 part  /boot
└─/dev/sda3                             8:3    0   63G  0 part
  └─/dev/mapper/ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
/dev/sdb                                8:16   0  2.5G  0 disk
├─/dev/sdb1                             8:17   0    2G  0 part
│ └─/dev/md1                            9:1    0    2G  0 raid1
└─/dev/sdb2                             8:18   0  511M  0 part
  └─/dev/md0                            9:0    0 1017M  0 raid0
    └─/dev/mapper/vg1-lvol0           253:1    0  100M  0 lvm
/dev/sdc                                8:32   0  2.5G  0 disk
├─/dev/sdc1                             8:33   0    2G  0 part
│ └─/dev/md1                            9:1    0    2G  0 raid1
└─/dev/sdc2                             8:34   0  511M  0 part
  └─/dev/md0                            9:0    0 1017M  0 raid0
    └─/dev/mapper/vg1-lvol0           253:1    0  100M  0 lvm
```
```
sudo lvs
  LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  ubuntu-lv ubuntu-vg -wi-ao----  31.50g
  lvol0     vg1       -wi-a----- 100.00m
```

11. Создайте `mkfs.ext4` ФС на получившемся LV.

```
sudo mkfs.ext4 /dev/vg1/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```

12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

```
mkdir /tmp/new
mount /dev/vg1/lvol0 /tmp/new
```

13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

```
sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2022-03-20 09:52:29--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22332110 (21M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                                           100%[=======================================================================================================================================>]  21.30M  5.68MB/s    in 4.4s    

2022-03-20 09:52:33 (4.88 MB/s) - ‘/tmp/new/test.gz’ saved [22332110/22332110]
```
```
ls /tmp/new
lost+found  test.gz
```

14. Прикрепите вывод `lsblk`.

```
lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md0                     9:0    0 1017M  0 raid0
    └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md0                     9:0    0 1017M  0 raid0
    └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
```

15. Протестируйте целостность файла:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
Выполнил, результат тот же

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
```
sudo pvmove /dev/md0
  /dev/md0: Moved: 12.00%
  /dev/md0: Moved: 100.00%
```
```
lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
│   └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
└─sdb2                      8:18   0  511M  0 part
  └─md0                     9:0    0 1017M  0 raid0
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
│   └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
└─sdc2                      8:34   0  511M  0 part
  └─md0                     9:0    0 1017M  0 raid0
```

17. Сделайте `--fail` на устройство в вашем RAID1 md.
```
sudo mdadm /dev/md1 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md1
```

18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

```
dmesg | grep md1
[ 8370.624822] md/raid1:md1: not clean -- starting background reconstruction
[ 8370.624824] md/raid1:md1: active with 2 out of 2 mirrors
[ 8370.624932] md1: detected capacity change from 0 to 2144337920
[ 8370.625762] md: resync of RAID array md1
[ 8381.519580] md: md1: resync done.
[14679.601055] md/raid1:md1: Disk failure on sdb1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.
```

19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
Выполнил, результат тот же, raid1 работает правильно!

20. Погасите тестовый хост, `vagrant destroy`.

```
vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
```