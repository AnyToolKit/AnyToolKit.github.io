case \$1 in
	base)
		# 更新与升级
		pkg update
		pkg upgrade

		# 安装欢迎界面列出来的软件
		pkg install -y root-repo x11-repo 

		# 安装基本的编辑工具
		pkg install -y vim

		# 安装常用工具
		pkg install -y net-tools git wget curl

		pkg install -y openssh
		;;
	*)
		# echo "用法：$0 {start|stop|status|restart}"
		echo "用法：\$0 {base}"
		;;
esac
