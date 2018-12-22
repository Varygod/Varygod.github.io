---
title: Mac配置vscode进行C++开发
date: 2018-12-22 20:05:32
tags: [Mac,IDE]
categories: 编程工具
---


![封面](http://image.varygod.top/15454806234276.png)
<!--more-->


#前言

平时工作做C/C++方面的开发更多还是在Windows下使用Visual Studio，Qt，CodeBlock等。自己的电脑是macOS下使用过IDE性质的XCode,CLion,Qt Creator，也使用过轻量级的诸如TextMate, Sublime Text，vim。但始终没有宇宙最强IDE---MS家族的VS。那种操作体验爽。废话少说了，直接上教程


# 需求

格式化
自动补全
Lint
符号检索
方便的跳转和查看
可视化调试

# 步骤
1.下载并安装[Visual Studio Code](https://code.visualstudio.com/)
2.检查自己的Mac是否安装了编译器，打开控制台。输入  `g++  -v` 和 `clang++  -v`
如下图
![](http://image.varygod.top/15454817848022.jpg)
3.然后回到VSCode去安装如下图所示的两款插件，以获得C++语法高亮、错误检查和调试等功能。

![](http://image.varygod.top/15454828019651.jpg)


![](http://image.varygod.top/15454829221331.jpg)


那么，前期准备工作完成后进入具体的配置阶段。首先在目录下新建一个文件夹作为工程目录，
然后在VSCode中打开该文件夹。在里面新建一个cpp文件命名为main.cpp。随意写点程序在里面。


```
#include<iostream>
#include<stdlib.h>
#include<stdio.h>
using namespace std;

int main(int argc, char const *argv[])
{
    cout<<"Hello~"<<endl;
    return 0;
}

```

![](http://image.varygod.top/15454830764372.jpg)

然后点击侧边栏的Debug按钮，点击设置图标，便会提示你选择环境，这里就选择C++那一项。
![-w951](http://image.varygod.top/15454838359758.jpg)

此时VSCode会在你的工程目录下自动新建一个.vscode的文件夹，并新建了一个launch.json的文件，这里需要对生成的文件进行一些小改动。本人配置如下：

```
{
    // 使用 IntelliSense 了解相关属性。 
    // 悬停以查看现有属性的描述。
    // 欲了解更多信息，请访问: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "(lldb) Launch",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/a.out",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": true,
            "MIMode": "lldb"
        }
    ]
}
```

保存后按快捷键⇧⌘B编译，此时会出现提示没有找到要运行的生成任务，所以接下来将进行生成任务的配置工作，VSCode提供了一些模版，有需要的可以自行选择，这里就选则Others。
![-w959](http://image.varygod.top/15454839095186.jpg)

![-w952](http://image.varygod.top/15454839296407.jpg)
![-w955](http://image.varygod.top/15454839446924.jpg)

此时.vscode目录下会出现一个task.json文件，对它进行改写。本人配置如下：


```
{
    // See https://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "2.0.0",
    "tasks": [
        {
            "label": "hello world",
            "type": "shell",
            "command": "clang++",
            "args": [
                "main.cpp"
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            }
        }
    ]
}
```

保存后再次按快捷键⇧⌘B就能够顺利编译了，编译完成后按F5执行，得到输出结果。
![](http://image.varygod.top/15454840061419.jpg)


每次编译完成后，我们会发现目录下多了一个a.out文件，这个文件是Linux/Unix环境下编译器编译源代码并连接产生的可执行文件，在未指定的情况下其默认命名为a.out。那么如何通过修改配置文件来修改这个文件的命名呢？
   方法很简单，在task.json中的args属性下填入-o yourfilename.out，以本人的配置作为示例：


```
{
    // See https://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "2.0.0",
    "tasks": [
        {
            "label": "hello world",
            "type": "shell",
            "command": "clang++",
            "args": [
                "-o app.out",
                "main.cpp"
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            }
        }
    ]
}
```

可以发现这里的command和args两个属性就相当于在命令行中执行了clang++ -o yourfilename.out main.cpp，所以如果还有其他的需求也可以对这里进行改写。最后不要忘记修改launch.json中的program属性，将.out的文件名修改为与task.json一致。便可以成功编译执行了。编译后结果如下图：
![](http://image.varygod.top/15454849598406.jpg)

