# dwm - dynamic window manager

dwm is an extremely fast, small, and dynamic window manager for X.

## Requirements

In order to build dwm you need the Xlib header files.

## Installation

Edit config.mk to match your local setup (dwm is installed into
the /usr/local namespace by default).

Afterwards enter the following command to build and install dwm (if
necessary as root):

    make clean install

## Running dwm

Add the following line to your .xinitrc to start dwm using startx:

    exec dwm

In order to connect dwm to a specific display, make sure that
the DISPLAY environment variable is set correctly, e.g.:

    DISPLAY=foo.bar:1 exec dwm

(This will start dwm on display :1 of the host foo.bar.)

In order to display status info in the bar, you can do something
like this in your .xinitrc:

    while xsetroot -name "`date` `uptime | sed 's/.*,//'`"
    do
    	sleep 1
    done &
    exec dwm

## Configuration

The configuration of dwm is done by creating a custom config.h
and (re)compiling the source code.

## Patches

1.  [autostart](https://dwm.suckless.org/patches/autostart/)

    - https://dwm.suckless.org/patches/autostart/dwm-autostart-20161205-bb3bd6f.diff

2.  dwm-statuscmd-20210405-67d76bd.diff

    - 支持状态栏信号控制

3.  dwm-alpha-20230401-348f655.diff

    - 状态栏支持透明

4.  修改状态栏选中色

    ```c
        static const char col_sel_bg[] = "#6C71C4";
        static const char col_sel_fg[] = "#ECEFF4";
        [SchemeSel]  = { col_sel_fg, col_sel_bg,  col_sel_bg  },

    ```

5.  dwm-fullgaps-6.4.diff
    - 给窗口增加间距

## 项目架构

```
dwm/
├── 核心源文件
│   ├── dwm.c          # 主程序源文件，包含窗口管理的核心逻辑
│   ├── drw.c          # 绘图相关函数的实现
│   ├── drw.h          # 绘图相关函数的声明
│   ├── util.c         # 通用工具函数的实现
│   └── util.h         # 通用工具函数的声明
│
├── 配置文件
│   ├── config.def.h   # 默认配置模板
│   ├── config.h       # 用户自定义配置（从 config.def.h 复制）
│   └── config.mk      # 编译配置，包含路径和编译选项
│
├── 补丁文件
│   ├── dwm-autostart-20161205-bb3bd6f.diff     # 自动启动功能补丁
│   ├── dwm-statuscmd-20210405-67d76bd.diff     # 状态栏信号控制补丁
│   ├── dwm-alpha-20230401-348f655.diff         # 状态栏透明补丁
│   └── dwm-fullgaps-6.4.diff                   # 窗口间距补丁
│
├── 编译文件
│   ├── Makefile       # 构建系统配置
│   ├── dwm.o         # dwm.c 的目标文件
│   ├── drw.o         # drw.c 的目标文件
│   └── util.o        # util.c 的目标文件
│
└── 文档
    ├── README.md      # 项目说明文档
    ├── LICENSE        # 许可证文件
    └── dwm.1         # man 手册页

```

### 文件说明

1. **核心源文件**
   - `dwm.c`: DWM 的核心实现，包含窗口管理、事件处理等主要功能
   - `drw.c/h`: 处理所有绘图相关的操作，如状态栏、标题等的渲染
   - `util.c/h`: 提供各种辅助函数，如字符串处理、内存管理等

2. **配置文件**
   - `config.def.h`: 默认配置模板，包含快捷键、外观等设置
   - `config.h`: 用户的个性化配置，基于 config.def.h 修改
   - `config.mk`: 定义编译选项、安装路径等构建系统配置

3. **补丁文件**
   - 包含多个功能增强补丁，每个补丁都提供特定的功能扩展
   - 补丁通过 patch 命令应用到源代码中

4. **编译文件**
   - `Makefile`: 定义构建规则和安装步骤
   - `.o` 文件: 编译生成的目标文件

5. **文档**
   - 包含项目说明、许可证和手册页
   - 提供安装、配置和使用说明

### 编译流程

1. 复制 `config.def.h` 到 `config.h`
2. 根据需要修改 `config.h` 中的配置
3. 执行 `make` 编译项目
4. 执行 `make install` 安装到系统

### 配置文件依赖说明

`config.def.h` 中的一些变量和类型依赖于 `dwm.c` 中的定义：

1. **来自 dwm.c 的常量定义**
   ```c
   #define OPAQUE                  0xffU    // 完全不透明
   #define LENGTH(X)               (sizeof X / sizeof X[0])
   #define TAGMASK                 ((1 << LENGTH(tags)) - 1)
   ```

2. **来自 dwm.c 的枚举定义**
   ```c
   enum { SchemeNorm, SchemeSel };    // 颜色主题枚举
   enum { NetSupported, NetWMName, NetWMState, NetWMCheck,
         NetSystemTray, NetSystemTrayOP, NetSystemTrayOrientation,
         NetSystemTrayOrientationHorz, NetWMFullscreen, NetActiveWindow,
         NetWMWindowType, NetWMWindowTypeDialog, NetClientList, NetLast };    // EWMH 原子
   enum { Manager, Xembed, XembedInfo, XLast };    // Xembed 原子
   ```

3. **来自 dwm.c 的结构体定义**
   ```c
   typedef union {
       int i;
       unsigned int ui;
       float f;
       const void *v;
   } Arg;    // 参数联合体

   typedef struct {
       unsigned int click;
       unsigned int mask;
       unsigned int button;
       void (*func)(const Arg *arg);
       const Arg arg;
   } Button;    // 按钮配置结构

   typedef struct {
       const char *symbol;
       void (*arrange)(Monitor *);
   } Layout;    // 布局配置结构
   ```

4. **来自 dwm.c 的函数声明**
   ```c
   static void spawn(const Arg *arg);
   static void tag(const Arg *arg);
   static void togglebar(const Arg *arg);
   static void focusstack(const Arg *arg);
   // ... 等更多函数
   ```

这就是为什么 `config.def.h` 单独检查时会报未定义错误，但在实际编译时是正常的 —— 因为这些定义都来自 `dwm.c`。在编译过程中，`config.h` 会被 `dwm.c` 包含，此时所有需要的定义都已经存在。

### 配置文件使用建议

1. 修改配置时，建议同时参考 `dwm.c` 中的相关定义
2. 如果遇到"未定义标识符"的警告，可以查看上述依赖说明
3. 实际编译时这些警告可以忽略，因为在完整编译过程中所有依赖都会被正确解析
