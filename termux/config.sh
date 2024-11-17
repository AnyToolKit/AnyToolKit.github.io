case $1 in
	base)						# 进行基本配置
		termux-setup-storage	# 获取访问手机存储的权限
		# 更新与升级
		pkg update
		pkg upgrade

		# 安装欢迎界面列出来的软件
		pkg install -y root-repo x11-repo 

		# 安装基本的编辑工具
		pkg install -y vim emacs

		# 安装常用工具
		pkg install -y net-tools git wget curl tree screen proot frp 

		pkg install -y openssh
		;;	
	CS)
		cp $PREFIX/etc/apt/sources.list $PREFIX/etc/apt/sources.list.bak
		sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list

		sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list

		sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list

		pkg update
		;;
	BaseBackup)
		termux-setup-storage
		cd $PREFIX/..
		tar -zcf /sdcard/termux-BaseBackup.tar.gz home usr		
		;;	
	backup)
		termux-setup-storage
		cd $PREFIX/..
		tar -zcf /sdcard/termux-backup.tar.gz home usr		
		;;
	restore)
		termux-setup-storage
		cd $PREFIX/..
		# --recursive-unlink：递归删除目标目录中的已存在文件/目录，防止解压时的冲突。
		# --preserve-permissions：保留文件的原始权限设置（包括所有者和用户组）。		
		tar -zxf /sdcard/termux-backup.tar.gz --recursive-unlink --preserve-permissions
		;;
	BaseRestore)
		termux-setup-storage
		cd $PREFIX/..
		tar -zxf /sdcard/termux-BaseBackup.tar.gz --recursive-unlink --preserve-permissions
		;;
	*)							# 默认显示用户信息
		# echo "用法：$0 {start|stop|status|restart}"
		echo "用法：$0 {base|CS|BaseBackup|Baserestore|backup|restore}"
		;;
esac
