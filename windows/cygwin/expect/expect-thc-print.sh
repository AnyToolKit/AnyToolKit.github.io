#!/usr/bin/expect
# 运行环境：Cygwin
# 编码：65001
# 设置编码方式：在Cygwin的家目录下的.bash_profile中添加语句：cmd /c chcp 65001
# 依赖环境：Cygwin安装expect
# 运行示例：expect thc.sh root@segfault.net segfault

set target_host [lindex $argv 0]
set passwd [lindex $argv 1]

set command_1 "info 1> /dev/null 2> temp.txt"
set command_2 "sed -n '/cat >/,/chmod 600/p' temp.txt"

# 检查参数数量
if {$argc < 1} {
	   # puts "Usage: $argv0 <target_host>"
	   puts "Usage:"
	   puts "expect $argv0 root@segfault.net segfault"
	   exit 1
   }         

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
					 send "$command_1\r"
					 send "$command_2\r"
					 send "exit\n"
					 break;
				 }
			 }		  
		 }		 		 
		 
		 interact
