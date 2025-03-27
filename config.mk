# DWM 版本号
VERSION = 6.4

# 根据您的系统自定义以下配置

# 路径配置
# 安装的基础目录，通常是 /usr/local
PREFIX = /usr/local
# 手册页安装目录
MANPREFIX = ${PREFIX}/share/man

# X11 相关路径
# X11 头文件目录
X11INC = /usr/X11R6/include
# X11 库文件目录
X11LIB = /usr/X11R6/lib

# Xinerama 支持（多显示器支持）
# 如果不需要多显示器支持，可以注释掉下面两行
XINERAMALIBS  = -lXinerama
XINERAMAFLAGS = -DXINERAMA

# FreeType 字体配置
# FreeType 库依赖
FREETYPELIBS = -lfontconfig -lXft
# FreeType 头文件目录
FREETYPEINC = /usr/include/freetype2
# OpenBSD 系统配置（需要时取消注释）
#FREETYPEINC = ${X11INC}/freetype2
#MANPREFIX = ${PREFIX}/man

# 包含文件和库文件配置
# 编译时的头文件包含路径
INCS = -I${X11INC} -I${FREETYPEINC}
# 链接时的库文件
LIBS = -L${X11LIB} -lX11 ${XINERAMALIBS} ${FREETYPELIBS} -lXrender

# 编译标志
# 预处理器标志：定义一些必要的宏和特性
CPPFLAGS = -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_XOPEN_SOURCE=700L -DVERSION=\"${VERSION}\" ${XINERAMAFLAGS}
# C 编译器标志
# 调试版本（已注释）：包含调试信息，无优化
#CFLAGS   = -g -std=c99 -pedantic -Wall -O0 ${INCS} ${CPPFLAGS}
# 发布版本：启用优化，显示所有警告
CFLAGS   = -std=c99 -pedantic -Wall -Wno-deprecated-declarations -Os ${INCS} ${CPPFLAGS}
# 链接器标志
LDFLAGS  = ${LIBS}

# Solaris 系统特殊配置（需要时取消注释）
#CFLAGS = -fast ${INCS} -DVERSION=\"${VERSION}\"
#LDFLAGS = ${LIBS}

# 编译器和链接器
# 使用的 C 编译器，通常是 gcc 或 clang
CC = cc
