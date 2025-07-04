#!/usr/bin/bash

# 定义总文件数组
apk_array=($(jq -r '.android.value[] | keys[]' cfg.json))
# printf '%s\n' "${apk_array[@]}"

# 定义要安装文件的数组
apk_files=()

# 两种文件下载方式：
# 方式一
# # 下载安装文件，如果文件已存在则跳过
# download_application() {  
#   while IFS= read -r url; do
#     if [[ "$url" == \$\(* ]]; then url=$(eval echo "$url"); fi    
#     apk_files+=($(basename "$url"))
#     if [[ ! -f $(basename "$url") ]]; then wget --no-check-certificate "$url"; fi
#   done < <(jq -r '.android.url[].[]' cfg.json)
# }
# 方式二
# 根据json文件中要下载文件对应的value判断是否下载，如果value值为y，则下载对应文件，否则跳过
download_application() {    
  for i in ${apk_array[@]}; do
    # printf '%s\n' $i;
    value=$(jq -r ".android.value[] | select(has(\"$i\")) | .\"$i\"" cfg.json)
    if [ "$value" == "y" ]; then
      url=$(jq -r ".android.url[] | select(has(\"$i\")) | .\"$i\"" cfg.json)
      if [[ "$url" == \$\(* ]]; then url=$(eval echo "$url"); fi
      # echo "$url"
      apk_files+=($(basename "$url"))
      if [[ ! -f $(basename "$url") ]]; then wget "$url"; fi
      
    fi
  done
}

# 安装文件
install_application() {    
  # printf '%s\n' "${apk_files[@]}"
  for i in  "${apk_files[@]}"; do
    adb -s $(adb devices | grep -w "device" | awk 'NR==1{print $1}') install "$i"
  done
  echo "所有程序已安装完成，如果要配置科学上网软件的订阅链接的话请按字母 p 健，然后等待python脚本自动配置，完成配置或不需要配置可按Ctrl-c结束"
}

function main() {
  set -e
  
  download_application
  install_application $1
}

main $1
