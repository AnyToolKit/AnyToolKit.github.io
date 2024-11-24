case $1 in
	base)						# 进行基本配置
		termux-setup-storage	# 获取访问手机存储的权限
		# 更新与升级
		pkg update
		pkg upgrade -y

		# 安装欢迎界面列出来的软件
		pkg install -y root-repo x11-repo 

		# 安装基本的编辑工具
		pkg install -y vim emacs

		# 安装常用工具
		pkg install -y net-tools git wget curl tree screen proot frp android-tools tmux gradle nginx which bc

		pkg install -y openssh
		;;
	tmuxConfig)
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
		tmux new -d -s temp_session
		cat > .tmux.conf << end
# 将下面内容复制到`~/.tmux.conf`
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible' # 
set -g @plugin 'tmux-plugins/tmux-yank' # tmux复制粘贴插件
set -g @plugin 'tmux-plugins/tmux-resurrect' # tmux永久保存插件(手动)
set -g @continuum-save-interval '15' # tmux永久保存插件(自动)，每隔15分钟自动保存一次
# set -g @continuum-save-interval '0' # 关闭自动备份
set -g @continuum-restore 'on' # 启用自动恢复，tmux启动时就恢复最后一次保存的会话环境
set -g status-right 'Continuum status: #{continuum_status}' # 此时状态栏会显示保存的时间间隔（单位为分钟）
set -g @plugin 'tmux-plugins/tmux-logging' # tmux日志
set -g history-limit 50000
# 记录日志：
# 在当前窗格中切换（开始/停止）日志记录。

# 按键绑定： prefix + shift + p

# 文件名格式： tmux-#{session_name}-#{window_index}-#{pane_index}-%Y%m%dT%H%M%S.log

# 文件路径：（

# $HOME
# 用户主目录）

# 示例文件： ~/tmux-my-session-0-1-20140527T165614.log
# 截取屏幕日志：
# 在当前窗格中保存可见文本。等效于“文本截图”。

# 按键绑定： prefix + alt + p
# 文件名格式： tmux-screen-capture-#{session_name}-#{window_index}-#{pane_index}-%Y%m%dT%H%M%S.log
# 文件路径：（$HOME 用户主目录）
# 示例文件： tmux-screen-capture-my-session-0-1-20140527T165614.log
# 保存完整的历史记录
# 将完整的窗格历史记录保存到文件。如果您回想起来很方便，则需要记录/保存所有工作。

# 按键绑定： prefix + alt + shift + p
# 文件名格式： tmux-history-#{session_name}-#{window_index}-#{pane_index}-%Y%m%dT%H%M%S.log
# 文件路径：（$HOME用户主目录）
# 示例文件： tmux-history-my-session-0-1-20140527T165614.log
# 注意：此功能取决于history-limit- 值Tmux在回滚缓冲区中保留的行数。Tmux保留的内容也只会保存到文件中。

# set -g history-limit 50000在.tmux.conf中使用，对于现代计算机，可以将此选项设置为高数字。

# 清除窗格历史记录
# 按键绑定： prefix + alt + c

# 这只是一个便捷键绑定。
# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'git@github.com/user/plugin'
# set -g @plugin 'git@bitbucket.com/user/plugin'
# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'	# 记住，这个必须放在.tumx.conf的底部
end
		~/.tmux/plugins/tpm/bin/install_plugins
		tmux kill-session -t temp_session
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
		echo "用法：$0 {base|tmuxConfig|CS|BaseBackup|BaseRestore|backup|restore}"
		echo "base：安装基本工具和常用工具"
		echo "tmuxconfig：配置tmux插件"
		echo "CS：换源，使用清华源"
		echo "BaseBackup：基本备份"
		echo "Baserestore：基本恢复"
		echo "backup：常规备份"
		echo "restore：常规恢复"
		;;
esac
