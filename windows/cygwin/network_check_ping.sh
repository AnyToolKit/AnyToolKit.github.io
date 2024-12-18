# cygwin编码环境：65001
# 在cygwin环境中设置编码：cmd /c chcp 65001
# 可以将设置编码的代码添加到cygwin环境的家目录下的 .bash_profile 文件中

check_str1="Media disconnected"

if [ $# -lt 1 ]; then
	echo "首先在Cygwin终端执行\"ipconfig -all\"获取对应以太网的网络适配器的描述名称，然后在运行脚本的时候作为参数传递给脚本"
	echo -e "\n示例："
	echo "$0 \"Intel(R) Ethernet Connection (7) I219-V\""
	echo "$0 \"Realtek PCIe GbE Family Controller\""
else
	echo -e "\n按Ctrl+c结束\n"

	i=0;
	while true; do
		# result=$(ipconfig -all | grep -A 4 -B 2 "Intel(R) Ethernet Connection (7) I219-V" | grep -w "Media disconnected" | awk -F ':' '{print $2}' | xargs)
		result=$(ipconfig -all | grep -A 4 -B 2 "$1" | grep -w "Media disconnected" | awk -F ':' '{print $2}' | xargs)	
		
		if [ "$result" != "" ]; then
			echo -e "\e[31m网络适配器未识别\e[0m"
		else
			echo -e "\n网络适配器已识别"
			echo -e "当前时间\e[33m$(date)\e[0m，第\e[32m$((++i))\e[0m次ping网口："
			ping -w 1 192.168.2.100 # 设置超时时间为1秒，默认为4秒
		fi
		sleep 0.5				# 延时500ms
	done
fi
