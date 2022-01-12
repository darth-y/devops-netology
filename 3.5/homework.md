# 3.5. Файловые системы

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

✅

1. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Ответ: Не могут, так как hardlink ссылаются на один и тот же объект, информация о котором фактически хранится в "общей" для этих линков inode. Т.о. изменение прав на "первом" файле автоматом изменит их на "втором".

1. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

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

1. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

```bash
root@vagrant:~# fdisk -l /dev/sdb
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x7804c190

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux
```

1. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

```bash
root@vagrant:~# sfdisk -d /dev/sdb | sfdisk -f /dev/sdc
...
root@vagrant:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop /snap/lxd/21029
loop2                       7:2    0 32.3M  1 loop /snap/snapd/12704
loop3                       7:3    0 43.3M  1 loop /snap/snapd/14295
loop4                       7:4    0 55.5M  1 loop /snap/core18/2253
loop5                       7:5    0 61.9M  1 loop /snap/core20/1270
loop6                       7:6    0 67.2M  1 loop /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
└─sdb2                      8:18   0  511M  0 part
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
└─sdc2                      8:34   0  511M  0 part
```

1. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

```bash
root@vagrant:~# mdadm --create --verbose /dev/md01 -l 1 -n 2 /dev/sd{b,c}1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md01 started.
mdadm: timeout waiting for /dev/md01
```

1. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

```bash
root@vagrant:~# mdadm --create --verbose /dev/md02 -l 0 -n 2 /dev/sd{b,c}2
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md02 started.
mdadm: timeout waiting for /dev/md02
```

1. Создайте 2 независимых PV на получившихся md-устройствах.

```bash
root@vagrant:~# pvcreate /dev/md{1,2}
  Physical volume "/dev/md1" successfully created.
  Physical volume "/dev/md2" successfully created.
```

1. Создайте общую volume-group на этих двух PV.

```bash
root@vagrant:~# vgcreate vg01 /dev/md{1,2}
  Volume group "vg01" successfully created
```

1. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

```bash
root@vagrant:~# lvcreate -L100M -n lv01 vg01 /dev/md2
  Logical volume "lv01" created.
  lv01      vg01      -wi-a----- 100.00m
root@vagrant:~# lvs -a -o +devices
  LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Devices

  ubuntu-lv ubuntu-vg -wi-ao----  31.50g                                                     /dev/sda3(0)
  lv01      vg01      -wi-a----- 100.00m                                                     /dev/md2(0)
```

1. Создайте `mkfs.ext4` ФС на получившемся LV.

```bash
root@vagrant:~# mkfs.ext4 /dev/mapper/vg01-lv01
```

1. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

```bash
root@vagrant:~# mkdir /tmp/new
root@vagrant:~# mount /dev/mapper/vg01-lv01 /tmp/new/
```

1. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

1. Прикрепите вывод `lsblk`.

```bash
root@vagrant:/tmp/new# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
loop2                       7:2    0 32.3M  1 loop  /snap/snapd/12704
loop3                       7:3    0 43.3M  1 loop  /snap/snapd/14295
loop4                       7:4    0 55.5M  1 loop  /snap/core18/2253
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1270
loop6                       7:6    0 67.2M  1 loop  /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md2                     9:2    0 1018M  0 raid0
    └─vg01-lv01           253:1    0  100M  0 lvm   /tmp/new
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md2                     9:2    0 1018M  0 raid0
    └─vg01-lv01           253:1    0  100M  0 lvm   /tmp/new
```

1. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
✅
	
1. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

```bash
root@vagrant:/tmp/new# pvmove /dev/md2
  /dev/md2: Moved: 8.00%
  /dev/md2: Moved: 100.00%
root@vagrant:/tmp/new# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
loop2                       7:2    0 32.3M  1 loop  /snap/snapd/12704
loop3                       7:3    0 43.3M  1 loop  /snap/snapd/14295
loop4                       7:4    0 55.5M  1 loop  /snap/core18/2253
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1270
loop6                       7:6    0 67.2M  1 loop  /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
│   └─vg01-lv01           253:1    0  100M  0 lvm   /tmp/new
└─sdb2                      8:18   0  511M  0 part
  └─md2                     9:2    0 1018M  0 raid0
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
│   └─vg01-lv01           253:1    0  100M  0 lvm   /tmp/new
└─sdc2                      8:34   0  511M  0 part
  └─md2                     9:2    0 1018M  0 raid0
```

1. Сделайте `--fail` на устройство в вашем RAID1 md.

```bash
root@vagrant:/tmp/new# mdadm /dev/md1 --fail /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md1
root@vagrant:/tmp/new#
root@vagrant:/tmp/new# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md2 : active raid0 sdc2[1] sdb2[0]
      1042432 blocks super 1.2 512k chunks

md1 : active raid1 sdc1[1](F) sdb1[0]
      2094080 blocks super 1.2 [2/1] [U_]

unused devices: <none>
root@vagrant:/tmp/new# mdadm -D /dev/md1
/dev/md1:
           Version : 1.2
     Creation Time : Wed Jan 12 19:36:10 2022
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Wed Jan 12 19:55:24 2022
             State : clean, degraded
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 1
     Spare Devices : 0

Consistency Policy : resync

              Name : vagrant:01  (local to host vagrant)
              UUID : 43c05705:acbce095:81a860b1:1cdc4cac
            Events : 21

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       -       0        0        1      removed

       1       8       33        -      faulty   /dev/sdc1
```

1. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

```bash
[Wed Jan 12 19:55:08 2022] md/raid1:md1: Disk failure on sdc1, disabling device.
                           md/raid1:md1: Operation continuing on 1 devices.
```

1. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```

1. Погасите тестовый хост, `vagrant destroy`.
