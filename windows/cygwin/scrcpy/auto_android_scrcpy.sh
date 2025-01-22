num_args=$#                                             # 获取参数数量

if [ "${num_args}" -eq 0 ]; then
  echo -e "Usage: \n$0 IPV4:Port"
elif [ "${num_args}" -eq 1 ]; then
  adb connect $1;
  # scrcpy -s $1 --no-audio -S &
  scrcpy -s $1 --no-audio --window-x 1920 --window-y 0 --window-height 1038 -S &
elif [ "$2" = "unlock" ]; then
  if [ "$3" = "" ]; then
	echo -e "Usage: \n$0 unlock passward"
  else
	adb -s $1 shell input keyevent 82; adb -s $1 shell input keyevent 82; sleep 0.4; adb -s $1 shell input text $3 && clear
  fi
elif [ "$2" = "rescrcpy" ]; then
  if [ "$3" = "" ]; then
	echo -e "Usage: \n$0 unlock passward"
  else
	adb -s $1 shell input keyevent 82; adb -s $1 shell input keyevent 82; sleep 0.4; adb -s $1 shell input text $3 && scrcpy -s $1 --no-audio -S && clear &
  fi
fi
