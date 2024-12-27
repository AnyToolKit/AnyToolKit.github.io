# 运行环境：Cygwin
# 编码：65001
# 设置编码方式：在Cygwin的家目录下的.bash_profile中添加语句：cmd /c chcp 65001
# 依赖环境：Cygwin安装expect
# 运行示例：expect thc.sh root@segfault.net segfault

#!/usr/bin/expect

# 检查参数数量
if {$argc < 1} {
       # puts "Usage: $argv0 <target_host>"
	   puts "expect $argv0 root@segfault.net segfault"
       exit 1
   }
   
   set target_host [lindex $argv 0]
   set passwd [lindex $argv 1]

   spawn ssh "$target_host"

   while {1} {
			 expect {
				 "yes/no" {
					 send "yes\r"
					 exp_continue
				 }
				 "password" {
					 send "$passwd\r"
					 exp_continue
				 }
				 "Press" {
					 send "\n"
					 exp_continue
				 }
				 "y/N" {
					 send "\n"
					 exp_continue
				 }
				 "root" {
					 break;
				 }
			 }		  
		 }

		 interact
