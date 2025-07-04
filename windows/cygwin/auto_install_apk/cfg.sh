#!/usr/bin/bash

# 定义总文件数组
apk_array=($(jq -r '.android.value[] | keys[]' cfg.json))
# printf '%s\n' "${apk_array[@]}"

# 定义要安装文件的数组
apk_files=()

# 下载安装文件，如果文件已存在则跳过
download_application() {    
  for i in ${apk_array[@]}; do
    # printf '%s\n' $i;
    value=$(jq -r ".android.value[] | select(has(\"$i\")) | .\"$i\"" cfg.json)
    if [ "$value" == "y" ]; then
      url=$(jq -r ".android.url[] | select(has(\"$i\")) | .\"$i\"" cfg.json)
      if [[ "$url" == \$\(* ]]; then url=$(eval echo "$url"); fi
      # echo "$url"
      apk_files+=($(basename "$url"))
      if [[ ! -f $(basename "$url") ]]; then wget --no-check-certificate "$url"; fi
      
    fi
  done
}

# 安装文件
install_application() {    
  # printf '%s\n' "${apk_files[@]}"
  for i in  "${apk_files[@]}"; do
    adb install "$i"
  done
}

function main() {
  set -e
  download_application
  install_application    
}

main
