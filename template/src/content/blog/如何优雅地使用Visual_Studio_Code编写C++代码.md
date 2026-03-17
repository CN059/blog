---
title: "如何优雅地使用 Visual Studio Code 编写 C++ 代码"
description: "使用 msys2 + mingw + cmake 配置 VSCode 的 C++ 开发环境详细教程"
pubDate: "May 14 2025"
heroImage: "https://image-host.powercess.com/Visual-Studio-Code.jpg"
---

提到开发C++应用程序，不知道你首先想到的是什么？是宇宙级IDE Visual Studio？JetBrains的Clion？还是什么其他的IDE？

对于初学者而言，我可能会无脑的给他推荐Visual Studio，其次是Clion。但是想要深入学习Cmake、C++开发工具链等知识的话，我建议使用Vscode，但是使用Vscode开发的话，那就需要稍微配置一下环境了(有一点复杂)。

废话不多说，让我们开始吧！(采用 msys2+mingw+cmake)

# 一、安装msys2

## 1.首先点击[msys2官网](https://www.msys2.org/)，进入之后是如下的界面

![image-20250505183408208](https://image-host.powercess.com/image-20250505183408208.png)

## 2.点击安装链接，下载msys2的安装包

![image-20250505183529045](https://image-host.powercess.com/image-20250505183529045.png)

## 3.进行msys2的安装

### (1)点击下一步

![image-20250505212626126](https://image-host.powercess.com/image-20250505212626126.png)

### (2)点击下一步

![image-20250505212742082](https://image-host.powercess.com/image-20250505212742082.png)

### (3)一直点击下一步直到安装

注意这里会卡到50%几分钟，耐心等待即可

![image-20250505212843449](https://image-host.powercess.com/image-20250505212843449.png)

### (4)点击finish完成msys2的安装

![image-20250505213316657](https://image-host.powercess.com/image-20250505213316657.png)

## 4.安装C++开发工具链

### (1)打开msys2-mingw

刚刚完成安装之后会弹出一个控制台，UCRT64，我们先关掉它

![image-20250505213522157](https://image-host.powercess.com/image-20250505213522157.png)

### (2)按下win+s键，搜索msys

打开图中框选为蓝色的

![image-20250505213618399](https://image-host.powercess.com/image-20250505213618399.png)

### (3)首先更新pacman软件仓库

在控制台执行该命令,更新pacman软件仓库

**注意，msys2是类unix的，所以无法通过ctrl+c，ctrl+v复制粘贴，需要按下键盘上的shift+insert(ins)键粘贴,shift+delete(del)键复制**

```
pacman -Syu
```

![image-20250505213940236](https://image-host.powercess.com/image-20250505213940236.png)

遇到这个问你是否继续安装的，直接按回车即可

![image-20250505214014986](https://image-host.powercess.com/image-20250505214014986.png)

然后控制台自动关闭了，重新打开即可

### (4)安装C++开发工具链

Mingw-w64是Windows编译C/C++源代码的程序集，为了安装该软件，须执行如下命令，即可安装编译C/C++程序所需的编译工具如：gcc、g++、make等。此步骤安装的软件包较多，因此可能需要一定时间，取决于网络和电脑配置，约需3-5分钟。

```
pacman -S --needed base-devel mingw-w64-x86_64-toolchain
```

遇到停顿的地方直接按回车即可

类似这样的输出表示安装成功

![image-20250505214447260](https://image-host.powercess.com/image-20250505214447260.png)

### (5)安装CMake(如果不需要可以跳过)

继续输入命令，安装CMake

```
pacman -S mingw-w64-x86_64-cmake
```

如果输出和下图类似代表安装成功

![image-20250505220708126](https://image-host.powercess.com/image-20250505220708126.png)

现在就可以关闭这个窗口了

### (6)配置mingw的bin目录到全局Path变量

按下win+e打开文件资源管理器

**找到你安装msys2的位置**

![image-20250505221024707](https://image-host.powercess.com/image-20250505221024707.png)

**进入mingw64目录**

进入bin目录

![image-20250505221133196](https://image-host.powercess.com/image-20250505221133196.png)

**复制路径**

![image-20250505221215525](https://image-host.powercess.com/image-20250505221215525.png)

**按下win+s键，搜索环境变量，打开下图中的内容**

![image-20250505220922519](https://image-host.powercess.com/image-20250505220922519.png)

**按图中内容点击**

![image-20250505221401447](https://image-host.powercess.com/image-20250505221401447.png)

![image-20250505221556771](https://image-host.powercess.com/image-20250505221556771.png)

**一路点击确定关闭**

![image-20250505221630977](https://image-host.powercess.com/image-20250505221630977.png)

**打开命令提示符(cmd)输入以下命令，若输出和途中类似，代表配置正确**

```
gcc --version
```

```
g++ --version
```

```
gdb --version
```

![image-20250505221821314](https://image-host.powercess.com/image-20250505221821314.png)

**到此，C++开发工具链部分配置完毕**

## 5.安装VSCode

### (1)进入VSCode官网下载

直接在浏览器搜索VSCode找到官网进入，或点击该链接直接进入[VSCode官网](https://code.visualstudio.com/)

### (2)点击下载按钮下载

![image-20250505214738773](https://image-host.powercess.com/image-20250505214738773.png)

### (3)运行安装文件

点击"我同意此协议"

![image-20250505215137702](https://image-host.powercess.com/image-20250505215137702.png)

### (4)这里可以修改路径为D盘，我这里默认C盘了

![image-20250505215219630](https://image-host.powercess.com/image-20250505215219630.png)

### (5)这里默认即可

![image-20250505215249566](https://image-host.powercess.com/image-20250505215249566.png)

### (6)我建议这里全部勾选上

![image-20250505215327417](https://image-host.powercess.com/image-20250505215327417.png)

### (7)安装！

![image-20250505215347276](https://image-host.powercess.com/image-20250505215347276.png)

### (8)点击完成

![image-20250505215441437](https://image-host.powercess.com/image-20250505215441437.png)

## 6.配置VSCode

### (1)首先打开VSCode，准备安装拓展

![image-20250505215608600](https://image-host.powercess.com/image-20250505215608600.png)

### (2)安装中文拓展(可选)

![image-20250505215830589](https://image-host.powercess.com/image-20250505215830589.png)

![image-20250505220037046](https://image-host.powercess.com/image-20250505220037046.png)

### (3)安装VSCode的C++拓展

![image-20250505220337738](https://image-host.powercess.com/image-20250505220337738.png)

## **7.配置CMake工程项目(如不需要可以跳过)**

### (1)打开一个空文件夹(路径最好不要有中文)

右键单击"**通过 Code 打开**"

![image-20250505222207280](https://image-host.powercess.com/image-20250505222207280.png)

点击"**信任**"，"**是，我信任此作者**"

![image-20250505222357505](https://image-host.powercess.com/image-20250505222357505.png)

### (2)创建CMake项目

**按下ctrl+shift+P**

![image-20250505222522680](https://image-host.powercess.com/image-20250505222522680.png)

![image-20250505222558492](https://image-host.powercess.com/image-20250505222558492.png)

![image-20250505222630709](https://image-host.powercess.com/image-20250505222630709.png)

![image-20250505222705677](https://image-host.powercess.com/image-20250505222705677.png)

![image-20250505222738312](https://image-host.powercess.com/image-20250505222738312.png)

![image-20250505222805381](https://image-host.powercess.com/image-20250505222805381.png)

![image-20250505222837593](https://image-host.powercess.com/image-20250505222837593.png)

![image-20250505222931074](https://image-host.powercess.com/image-20250505222931074.png)

![image-20250505223027066](https://image-host.powercess.com/image-20250505223027066.png)

![image-20250505223241997](https://image-host.powercess.com/image-20250505223241997.png)

![image-20250505223346777](https://image-host.powercess.com/image-20250505223346777.png)

## 8.直接使用C++开发工具链编写代码

### (1)初始化一个新项目

![image-20250506181006186](https://image-host.powercess.com/image-20250506181006186.png)

![image-20250506181603029](https://image-host.powercess.com/image-20250506181603029.png)

### (2)配置工具链

直接点击右上角的运行

![image-20250506182419112](https://image-host.powercess.com/image-20250506182419112.png)

![image-20250506182443591](https://image-host.powercess.com/image-20250506182443591.png)

出现类似下图的状态代表配置成功！

![image-20250506182542785](https://image-host.powercess.com/image-20250506182542785.png)

### (3)使用code run拓展简化输出

通过上述过程你也看到了，每次运行都会有大量的乱七八糟的输出，如何屏蔽掉呢？

其实很简单，安装一个拓展即可

![image-20250506182707788](https://image-host.powercess.com/image-20250506182707788.png)

打开拓展商店，安装该拓展

之后，你的右上角变成了这样

![image-20250506182828237](https://image-host.powercess.com/image-20250506182828237.png)

点击Run Code或按下ctrl+alt+N即可快速运行

效果如图

![image-20250506182908256](https://image-host.powercess.com/image-20250506182908256.png)

### (4)调试功能

其实如果你刚才配置一切正常的话，现在点击右上角调试按钮，直接就可以打断点调试，如图

![image-20250506183013878](https://image-host.powercess.com/image-20250506183013878.png)

至此，VSCode的C++开发环境配置完毕。后续更新CMake第三方库的导入相关教程。
