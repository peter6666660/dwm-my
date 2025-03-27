# dwm - 动态窗口管理器
# 查看 LICENSE 文件获取版权和许可证详细信息

# 包含编译配置文件，定义了编译器选项、安装路径等
include config.mk

# 定义源代码文件列表
SRC = drw.c dwm.c util.c
# 通过将 .c 替换为 .o 生成目标文件列表
OBJ = ${SRC:.c=.o}

# 默认目标：构建 dwm
all: dwm

# 编译规则：将 .c 文件编译为 .o 文件
# $< 表示第一个依赖项（源文件）
.c.o:
	${CC} -c ${CFLAGS} $<

# 所有目标文件都依赖于这两个配置文件
${OBJ}: config.h config.mk

# 如果 config.h 不存在，从 config.def.h 复制一份
# $@ 表示目标文件名（config.h）
config.h:
	cp config.def.h $@

# 链接规则：将所有 .o 文件链接成最终的 dwm 可执行文件
dwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

# 清理规则：删除所有编译生成的文件
clean:
	rm -f dwm ${OBJ} dwm-${VERSION}.tar.gz

# 打包发布规则：创建发布包
dist: clean
	# 创建临时目录
	mkdir -p dwm-${VERSION}
	# 复制所有源代码和配置文件到临时目录
	cp -R LICENSE Makefile README config.def.h config.mk\
		dwm.1 drw.h util.h ${SRC} dwm.png transient.c dwm-${VERSION}
	# 打包成 tar 文件
	tar -cf dwm-${VERSION}.tar dwm-${VERSION}
	# 用 gzip 压缩
	gzip dwm-${VERSION}.tar
	# 删除临时目录
	rm -rf dwm-${VERSION}

# 安装规则：安装 dwm 到系统
install: all
	# 创建二进制文件安装目录
	mkdir -p ${DESTDIR}${PREFIX}/bin
	# 复制 dwm 可执行文件
	cp -f dwm ${DESTDIR}${PREFIX}/bin
	# 设置可执行权限
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	# 创建手册页目录
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	# 替换手册中的版本号并安装
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
	# 设置手册页权限
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1

# 卸载规则：从系统中删除 dwm
uninstall:
	# 删除已安装的文件
	rm -f ${DESTDIR}${PREFIX}/bin/dwm\
		${DESTDIR}${MANPREFIX}/man1/dwm.1

# 声明伪目标（这些目标不会生成实际的文件）
.PHONY: all clean dist install uninstall
