check_str1="Media disconnected"

if [ $# -lt 1 ]; then
	echo "首先在Cygwin终端执行\"ipconfig -all\"获取对应以太网的网络适配器的描述名称，然后在运行脚本的时候作为参数传递给脚本"
	echo -e "\n示例："
	echo "$0 \"Intel(R) Ethernet Connection (7) I219-V\""
else
	echo -e "\n按Ctrl+c结束\n"

	i=0;
	while true; do
		# result=$(ipconfig -all | grep -A 4 -B 2 "Intel(R) Ethernet Connection (7) I219-V" | grep -w "Media disconnected" | awk -F ':' '{print $2}' | xargs)
		result=$(ipconfig -all | grep -A 4 -B 2 "$1" | grep -w "Media disconnected" | awk -F ':' '{print $2}' | xargs)	
		
		if [ "$result" != "" ]; then
			echo "网络适配器未识别"
		else
			echo -e "\n网络适配器已识别"
			echo -e "当前时间$(date)，第$((++i))次ping网口："
			ping -w 1 192.168.2.100 # 设置超时时间为1秒，默认为4秒
		fi
		sleep 0.5				# 延时500ms
	done
fi
