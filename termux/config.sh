case $1 in
	base)						# 进行基本配置
		# 更新与升级
		pkg update
		pkg upgrade

		# 安装欢迎界面列出来的软件
		pkg install -y root-repo x11-repo 

		# 安装基本的编辑工具
		pkg install -y vim emacs

		# 安装常用工具
		pkg install -y net-tools git wget curl

		pkg install -y openssh
		;;
	CS)
		sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list

		sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list

		sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list

		pkg update
		;;
	*)							# 默认显示用户信息
		# echo "用法：$0 {start|stop|status|restart}"
		echo "用法：$0 {base|CS}"
		;;
esac
