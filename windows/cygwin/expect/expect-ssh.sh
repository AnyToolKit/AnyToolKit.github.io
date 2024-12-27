#!/usr/bin/expect

# 检查参数数量
if {$argc < 1} {
       puts "Usage: $argv0 <target_host>"
       exit 1
   }

   set target_host [lindex $argv 0]

   spawn ssh "$target_host"

   expect {
	   "yes/no" {
		   send "yes\r"
		   exp_continue
	   }
   }

   while {1} {
			 expect {
				 "Press" {
					 send "\n"
					 exp_continue
				 }
				 "y/N" {
					 send "\n"
					 exp_continuel
				 }
				 "root" {
					 break;
				 }
			 }		  
		 }

		 interact
