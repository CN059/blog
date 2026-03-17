---
title: "ArchLinux 虚拟机安装指南"
description: "从零开始，在虚拟机中安装 ArchLinux 操作系统的完整教程"
pubDate: "Aug 31 2025"
heroImage: "https://image-host.powercess.com/OIP-C.webp"
---

# ArchLinux虚拟机安装指南

玩够了Ubuntu，还是觉得Ubuntu东西太多怎么办？试试Archlinux（

注意，本文章参考[archlinux 基础安装 | archlinux 简明指南](https://arch.icekylin.online/guide/rookie/basic-install.html)撰写，如有侵权请联系删除

## 创建虚拟机

![image-20250831095124206](https://image-host.powercess.com/image-20250831095124206.png)

![image-20250831095145045](https://image-host.powercess.com/image-20250831095145045.png)

![image-20250831095202893](https://image-host.powercess.com/image-20250831095202893.png)

![image-20250831095307575](https://image-host.powercess.com/image-20250831095307575.png)

![image-20250831095516809](https://image-host.powercess.com/image-20250831095516809.png)

![image-20250831095651660](https://image-host.powercess.com/image-20250831095651660.png)

![image-20250831095723093](https://image-host.powercess.com/image-20250831095723093.png)

![image-20250831095745526](https://image-host.powercess.com/image-20250831095745526.png)

![image-20250831095800788](https://image-host.powercess.com/image-20250831095800788.png)

![image-20250831095815893](https://image-host.powercess.com/image-20250831095815893.png)

![image-20250831095830253](https://image-host.powercess.com/image-20250831095830253.png)

![image-20250831095938991](https://image-host.powercess.com/image-20250831095938991.png)

![image-20250831095959119](https://image-host.powercess.com/image-20250831095959119.png)

![image-20250831100020151](https://image-host.powercess.com/image-20250831100020151.png)

![image-20250831100035909](https://image-host.powercess.com/image-20250831100035909.png)

![image-20250831100241435](https://image-host.powercess.com/image-20250831100241435.png)

![image-20250831100507006](https://image-host.powercess.com/image-20250831100507006.png)

![image-20250831100523436](https://image-host.powercess.com/image-20250831100523436.png)

![image-20250831100543463](https://image-host.powercess.com/image-20250831100543463.png)

![image-20250831100648340](https://image-host.powercess.com/image-20250831100648340.png)

**现在就可以通过命令安装系统了**

## 安装ArchLinux操作系统到磁盘

### 1. 禁用 reflector 服务

2020 年，archlinux 安装镜像中加入了 `reflector` 服务，它会自己更新 `mirrorlist`（软件包管理器 `pacman` 的软件源）。在特定情况下，它会误删某些有用的源信息。这里进入安装环境后的第一件事就是将其禁用。也许它是一个好用的工具，但是很明显，因为地理上造成的特殊网络环境，这项服务并不适合启用。

###### 1.通过以下命令将该服务禁用：

```
systemctl stop reflector.service
```

###### 2.通过以下命令查看该服务是否被禁用，按下 `q` 退出结果输出：

```
systemctl status reflector.service
```

![image-20250831101152785](https://image-host.powercess.com/image-20250831101152785.png)

###### 补充：

如何方便的把指令粘贴到虚拟机里，我们按下`将光标移出虚拟机的黑窗口`

![image-20250831101544979](https://image-host.powercess.com/image-20250831101544979.png)

然后按下`ctrl + v`即可把命令复制进去

然后鼠标再移回去，就可以操作了

### 2. 确认是否是UEFI模式

禁用 `reflector` 服务后，我们再来确认一下是否为 `UEFI` 模式：

```
ls /sys/firmware/efi/efivars
```

![image-20250831101802260](https://image-host.powercess.com/image-20250831101802260.png)

### 3. 测试网络连通性

确保虚拟机已联通网络，所以需要测试网络连通性

通过 `ping` 命令测试网络连通性：

```
ping www.bilibili.com
```

![image-20250831102004725](https://image-host.powercess.com/image-20250831102004725.png)

按下`ctrl + c`终止ping命令，只要有类似上图的输出就代表已联网

### 4. 更新系统时钟

使用 `timedatectl` 确保系统时间是准确的。这一步**不是**可选的，正确的系统时间对于部分程序来说非常重要：

```
timedatectl set-ntp true # 将系统时间与网络时间进行同步
timedatectl status # 检查服务状态
```

![image-20250831102240328](https://image-host.powercess.com/image-20250831102240328.png)

### 5. 更换国内软件仓库镜像源加快下载速度

使用 `vim` 编辑器修改 `/etc/pacman.d/mirrorlist` 文件。将 `pacman` 软件仓库源更换为国内软件仓库镜像源：

```
vim /etc/pacman.d/mirrorlist
```

放在最上面的是会使用的软件仓库镜像源，推荐的镜像源如下：

```
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch # 清华大学开源软件镜像站
Server = http://mirrors.aliyun.com/archlinux/$repo/os/$arch # 阿里云镜像站
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch # 中国科学技术大学开源镜像站
Server = https://repo.huaweicloud.com/archlinux/$repo/os/$arch # 华为开源镜像站
Server = http://mirror.lzu.edu.cn/archlinux/$repo/os/$arch # 兰州大学开源镜像站
```

![image-20250831103241960](https://image-host.powercess.com/image-20250831103241960.png)

### 6. 分区和格式化（使用 Btrfs 文件系统）

#### 分区

###### 1.通过 `lsblk` 命令，区分要安装 archlinux 的磁盘（通过观察磁盘的大小、已存在的分区情况等判断）并显示当前磁盘的分区情况：

```
lsblk # 显示当前分区情况
```

![image-20250831103455004](https://image-host.powercess.com/image-20250831103455004.png)

这里的sda就是待会要分区的硬盘

###### 2.接下来使用 `cfdisk` 命令对磁盘分区（对于 SATA 协议的硬盘，`x` 为字母 `a`、`b` 或 `c` 等等；对于 NVME 协议的硬盘，`x` 为数字 `0`、`1` 或 `2` 等等，请根据实际情况判断）：

```
cfdisk /dev/sda # 对安装 archlinux 的磁盘分区
```

![image-20250831103725838](https://image-host.powercess.com/image-20250831103725838.png)

进入 `cfdisk` 分区工具之后，你会看到如图所示的界面。通过方向键 `↑` 和 `↓` 可以在要操作磁盘分区或空余空间中移动；通过方向键 `←` 和 `→` 在对当前高亮的磁盘分区或空余空间要执行的操作中移动。

###### 3.首先创建EFI分区，存储操作系统引导选中 `Free space` > 再选中操作 `[New]` > 然后按下回车 `Enter` 以新建 `EFI` 分区

![image-20250831104102027](https://image-host.powercess.com/image-20250831104102027.png)

###### 4.按下回车后会提示输入 `分区大小`，EFI 分区我直接设置为了1G， 然后按下回车 `Enter`

![image-20250831104744066](https://image-host.powercess.com/image-20250831104744066.png)

###### 6.默认新建的类型是 `Linux filesystem`，我们需要将类型更改为 `Linux swap`。选中操作 `[Type]` > 然后按下回车 `Enter` > 通过方向键 `↑` 和 `↓` 选中 `EFI` > 最后按下回车 `Enter`

![image-20250831104820163](https://image-host.powercess.com/image-20250831104820163.png)

![image-20250831104846324](https://image-host.powercess.com/image-20250831104846324.png)

###### 7.然后创建 Swap 分区。和上面一样的流程，只不过文件类型是`Linux swap`，Swap 分区建议为**电脑内存大小的 60%**，或者和内存大小相等，我这里直接设置为4G了，因为我虚拟机设置的内存大小就是4G，然后按下回车 `Enter`

![image-20250831105040351](https://image-host.powercess.com/image-20250831105040351.png)

###### 8.我们再只需要一个分区即可（因为使用 `Btrfs` 文件系统，所以根目录和用户主目录在一个分区上），所以类似的：选中 `Free space` > 再选中操作 `[New]` > 然后按下回车 `Enter` 以新建分区，剩下的空间全部分配就行了

![image-20250831105105446](https://image-host.powercess.com/image-20250831105105446.png)

###### 9.接下来选中操作 `[Write]` 并回车 `Enter` > 输入 `yes` 并回车 `Enter` 确认分区操作

![image-20250831105335154](https://image-host.powercess.com/image-20250831105335154.png)

![image-20250831105351595](https://image-host.powercess.com/image-20250831105351595.png)

![image-20250831105403387](https://image-host.powercess.com/image-20250831105403387.png)

如果不放心，可以再打开检查一下

![image-20250831105427185](https://image-host.powercess.com/image-20250831105427185.png)

确认无误

###### 10.分区完成后，使用 `fdisk` 或 `lsblk` 命令复查分区情况：

![image-20250831105540523](https://image-host.powercess.com/image-20250831105540523.png)

#### 格式化并创建 Btrfs 子卷

###### 1.格式化 EFI 分区

```
mkfs.fat -F32 /dev/sda1
```

![image-20250831105659405](https://image-host.powercess.com/image-20250831105659405.png)

###### 2.格式化 Swap 分区

```
mkswap /dev/sda2
```

###### 3.格式化 Btrfs 分区

**1.首先我们需要将整一个分区格式化为 `Btrfs` 文件系统。使用如下命令进行格式化：**

```
mkfs.btrfs -L Arch /dev/sda3
```

![image-20250831105914802](https://image-host.powercess.com/image-20250831105914802.png)

- `-L` 选项后指定该分区的 `LABLE`，这里以 `myArch` 为例，也可以自定义，但不能使用特殊字符以及空格，且最好有意义

  2.**为了创建子卷，我们需要先将 `Btrfs` 分区挂载到 `/mnt` 下：**

```
mount -t btrfs -o compress=zstd /dev/sda3 /mnt
```

- `-t` 选项后指定挂载分区文件系统类型
- `-o` 选项后添加挂载参数：
  - `compress=zstd` —— 开启透明压缩

**3.使用 `df` 命令复查挂载情况：**

```
df -h # -h 选项会使输出以人类可读的单位显示
```

![image-20250831110147784](https://image-host.powercess.com/image-20250831110147784.png)

###### 4.创建 Btrfs 子卷

**1.通过以下命令创建两个 `Btrfs` 子卷，之后将分别挂载到 `/` 根目录和 `/home` 用户主目录：**

```
btrfs subvolume create /mnt/@ # 创建 / 目录子卷
btrfs subvolume create /mnt/@home # 创建 /home 目录子卷
```

![image-20250831110600008](https://image-host.powercess.com/image-20250831110600008.png)

**2.通过以下命令复查子卷情况：**

```
btrfs subvolume list -p /mnt
```

![image-20250831110734868](https://image-host.powercess.com/image-20250831110734868.png)

**3.子卷创建好后，我们需要将 `/mnt` 卸载掉，以挂载子卷：**

```
umount /mnt
```

![image-20250831110836925](https://image-host.powercess.com/image-20250831110836925.png)

### 7.挂载

**1.在挂载时，挂载是有顺序的，需要从根目录开始挂载。使用如下命令挂载子卷：**

```
mount -t btrfs -o subvol=/@,compress=zstd /dev/sda3 /mnt # 挂载 / 目录
mkdir /mnt/home # 创建 /home 目录
mount -t btrfs -o subvol=/@home,compress=zstd /dev/sda3 /mnt/home # 挂载 /home 目录
mkdir -p /mnt/boot # 创建 /boot 目录
mount /dev/sda1 /mnt/boot # 挂载 /boot 目录
swapon /dev/sda2 # 挂载交换分区
```

![image-20250831111357122](https://image-host.powercess.com/image-20250831111357122.png)

**2.使用 `df` 命令复查挂载情况：**

```
df -h
```

![image-20250831111510518](https://image-host.powercess.com/image-20250831111510518.png)

**3.使用 `free` 命令复查 Swap 分区挂载情况：**

```
free -h # -h 选项会使输出以人类可读的单位显示
```

![image-20250831111542829](https://image-host.powercess.com/image-20250831111542829.png)

### 8.安装系统

###### 1.通过如下命令使用 `pacstrap` 脚本安装基础包：

```
pacstrap /mnt base base-devel linux linux-firmware btrfs-progs
# 如果使用btrfs文件系统，额外安装一个btrfs-progs包
```

- `base-devel` —— `base-devel` 在 `AUR` 包的安装过程中是必须用到的
- `linux` —— 内核软件包，这里建议先不要替换为其它内核

![image-20250831111803204](https://image-host.powercess.com/image-20250831111803204.png)

![image-20250831111939324](https://image-host.powercess.com/image-20250831111939324.png)

###### 2.通过如下命令使用 `pacstrap` 脚本安装其它必要的功能性软件：

```
pacstrap /mnt networkmanager neovim sudo zsh zsh-completions
```

我因为喜欢用neovim，所以安装的neovim，可以用vim

![image-20250831112255719](https://image-host.powercess.com/image-20250831112255719.png)

### 9.生成 fstab 文件

###### 1.`stab` 用来定义磁盘分区。它是 Linux 系统中重要的文件之一。使用 `genfstab` 自动根据当前挂载情况生成并写入 `fstab` 文件：

```
genfstab -U /mnt > /mnt/etc/fstab
```

###### 2.复查一下 `/mnt/etc/fstab` 确保没有错误：

```
cat /mnt/etc/fstab
```

![image-20250831112424615](https://image-host.powercess.com/image-20250831112424615.png)

### 10.change root

使用以下命令把系统环境切换到新系统下：

```
arch-chroot /mnt
```

![image-20250831112505529](https://image-host.powercess.com/image-20250831112505529.png)

此时，原来安装盘下的 `/mnt` 目录就变成了新系统的 `/` 目录。同时，可以发现命令行的提示符颜色和样式也发生了改变。

### 11.设置主机名与时区

###### 1.首先在 `/etc/hostname` 设置主机名：

```bash
nvim /etc/hostname
```

我这里起名叫Arch了

![image-20250831112657776](https://image-host.powercess.com/image-20250831112657776.png)

###### 2.接下来在 `/etc/hosts` 设置与其匹配的条目：

```bash
nvim /etc/hosts
```

加入如下内容：

```
127.0.1.1   Arch.localdomain Arch
```

![image-20250831112847939](https://image-host.powercess.com/image-20250831112847939.png)

###### 3.随后设置时区，在 `/etc/localtime` 下用 `/usr` 中合适的时区创建符号链接：

```bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

### 12.硬件时间设置

使用如下命令将系统时间同步到硬件时间：

```bash
hwclock --systohc
```

![image-20250831113023663](https://image-host.powercess.com/image-20250831113023663.png)

### 13.设置 Locale

`Locale` 决定了软件使用的语言、书写习惯和字符集。

###### 1.编辑 `/etc/locale.gen`，去掉 `en_US.UTF-8 UTF-8` 以及 `zh_CN.UTF-8 UTF-8` 行前的注释符号（`#`）：

```
nvim /etc/locale.gen
```

![image-20250831113129071](https://image-host.powercess.com/image-20250831113129071.png)

![image-20250831113150120](https://image-host.powercess.com/image-20250831113150120.png)

###### 2.然后使用如下命令生成 `locale`：

```bash
locale-gen
```

![image-20250831113230572](https://image-host.powercess.com/image-20250831113230572.png)

###### 3.向 `/etc/locale.conf` 输入内容：

```bash
echo 'LANG=en_US.UTF-8'  > /etc/locale.conf
```

![image-20250831113315842](https://image-host.powercess.com/image-20250831113315842.png)

### 14.为 root 用户设置密码

```bash
passwd root
```

![image-20250831113402155](https://image-host.powercess.com/image-20250831113402155.png)

这里输入，不会显示出东西来，但实际上已经输入进去了，我这里输入的密码是root

### 15.安装微码

通过以下命令安装对应芯片制造商的微码：

```bash
pacman -S intel-ucode # Intel
pacman -S amd-ucode # AMD
```

![image-20250831113551518](https://image-host.powercess.com/image-20250831113551518.png)

### 16.安装引导程序

###### 1.安装相应的包：

```bash
pacman -S grub efibootmgr
```

`-S` 选项后指定要通过 `pacman` 包管理器安装的包：

- `grub` —— 启动引导器
- `efibootmgr` —— `efibootmgr` 被 `grub` 脚本用来将启动项写入 NVRAM

![image-20250831113826858](https://image-host.powercess.com/image-20250831113826858.png)

###### 2.安装 GRUB 到 EFI 分区：

```
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
```

![image-20250831113840298](https://image-host.powercess.com/image-20250831113840298.png)

- `--efi-directory=/boot` —— 将 `grubx64.efi` 安装到之前的指定位置（EFI 分区）
- `--bootloader-id=Arch` —— 取名为 `Arch`

###### 3.接下来使用 `nvim` 编辑 `/etc/default/grub` 文件：

```bash
nvim /etc/default/grub
```

进行如下修改：

- 去掉 `GRUB_CMDLINE_LINUX_DEFAULT` 一行中最后的 `quiet` 参数
- 把 `loglevel` 的数值从 `3` 改成 `5`。这样是为了后续如果出现系统错误，方便排错
- 加入 `nowatchdog` 参数，这可以显著提高开关机速度

![image-20250831114041565](https://image-host.powercess.com/image-20250831114041565.png)

###### 4.最后生成 `GRUB` 所需的配置文件：

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

![image-20250831114133024](https://image-host.powercess.com/image-20250831114133024.png)

### 17.完成安装

输入以下命令

```
exit # 退回安装环境
umount -R /mnt # 卸载新分区
poweroff # 关机
```

![image-20250831114230686](https://image-host.powercess.com/image-20250831114230686.png)

![image-20250831114531397](https://image-host.powercess.com/image-20250831114531397.png)

## 开机

![image-20250831114604213](https://image-host.powercess.com/image-20250831114604213.png)

![image-20250831114631199](https://image-host.powercess.com/image-20250831114631199.png)

输入用户名和密码

![image-20250831114701135](https://image-host.powercess.com/image-20250831114701135.png)

成功登录
