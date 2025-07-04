# coding: utf-8
#
import signal
import sys
import subprocess
import uiautomator2 as u2
import keyboard
import json
import time

def get_device_id():
    # 获取第第一个已连接的Android设备ID
    try:
        result = subprocess.check_output(['adb', 'devices']).decode('utf-8')
        devices = [line.split('\t')[0]
            for line in result.splitlines()
            if '\tdevice' in line]
        return devices[0] if devices else None
    except (subprocess.CalledProcessError, IndexError):
        return None

def signal_handler(signal, frame):
    # print('Caught Ctrl+C / SIGINT signal')
    # 在这里添加你想要做的清理操作
    # 例如停止子进程，关闭文件等
    # ...
    # 退出程序的代码
    sys.exit(0)

# def parse_json_airport():
#     with open('cfg.json', 'r') as fcc_file:
#         fcc_data = json.load(fcc_file)
#         print(fcc_data)
def parse_json_airport():
    with open('cfg.json', 'r') as file:
        data = file.read()
        data_dict = json.loads(data)
        # name_value = data_dict['airport']
        # print(name_value)
        # # 或
        # airport_value = data_dict.get('airport', 'airport not found')
        # print(f"Name: {name_value}, airport: {airport_value}")
        sub_value=data_dict['airport'] ['airport_name']
        # print(test_value)
        return sub_value    
    
def main():
    running = True
    
    device_id = get_device_id()    
    if not device_id:
        print("Error: No connect Android device found")
        sys.exit(1)

    print(f"Connected device: {device_id}")

    # 初始化uiautomator2连接
    try:
        d = u2.connect(device_id)
        print("Device connected successfully")
        
        while running:
            try:
                # 检测元素A是否存在
                if d(resourceId="com.android.packageinstaller:id/vbutton_title", text="继续安装").exists(timeout=0):
                    d(resourceId="com.android.packageinstaller:id/vbutton_title", text="继续安装").click()        
                    print("点击元素")
                    time.sleep(1)  # 操作后等待页面稳定
                    continue  # 回到循环开头重新检测
                elif keyboard.is_pressed('p'): 
                    print("按下了键盘上的 p 键，暂停while循环")

                    # 配置科学上网软件的订阅链接
                    print("开始配置科学上网软件的订阅链接")
                    print("开始调用 parse_json_airport()")
                    airport_sub_value = parse_json_airport() # 获取json文件中配置的订阅链接

                    # 以下两个软件的界面操作是根据软件界面的实际控件进行操作的，如果更换其他软件了，请根据软件的控制进行修改
                    print("配置v2rayNG订阅链接")
                    d.app_stop('com.v2ray.ang')
                    d.app_start('com.v2ray.ang')    
                    d(description="Open navigation drawer").click()    
                    d(resourceId="com.v2ray.ang:id/design_menu_item_text", text="订阅分组设置").click()
                    d(resourceId="com.v2ray.ang:id/add_config").click()
                    d(resourceId="com.v2ray.ang:id/et_remarks").click()
                    d.send_keys("tolink", clear=True)
                    d(resourceId="com.v2ray.ang:id/et_url").click()                    
                    d.send_keys(airport_sub_value, clear=True)
                    d(resourceId="com.v2ray.ang:id/save_config").click()
                    time.sleep(1.5)
                    d.app_stop('com.v2ray.ang')

                    print("配置clash-meta订阅链接")
                    d.app_stop('com.github.metacubex.clash.meta')
                    d.app_start('com.github.metacubex.clash.meta')
                    d(resourceId="com.github.metacubex.clash.meta:id/text_view", text="配置").click()
                    d(resourceId="com.github.metacubex.clash.meta:id/add_view").click()
                    d.xpath('//*[@resource-id="com.github.metacubex.clash.meta:id/main_list"]/android.widget.LinearLayout[2]').click()
                    d(resourceId="com.github.metacubex.clash.meta:id/text_view", text="新配置").click()
                    d.send_keys("tolink", clear=True)    
                    d(resourceId="android:id/button1").click()
                    d(resourceId="com.github.metacubex.clash.meta:id/text_view", text="仅接受 http(s) 和 content 类型").click()                    
                    d.send_keys(airport_sub_value, clear=True)
                    d(resourceId="android:id/button1").click()
                    d(resourceId="com.github.metacubex.clash.meta:id/action_layout").click()
                    d.xpath('//*[@resource-id="com.github.metacubex.clash.meta:id/main_list"]/android.widget.RelativeLayout[1]/android.widget.RadioButton[1]').click()
                    time.sleep(1.5)
                    d.app_stop('com.github.metacubex.clash.meta')
                    
                    input("按回车继续，然后按字母 q 键退出或按 Ctrl-c 结束")
                elif keyboard.is_pressed('q'):                    
                    print("按下了键盘上的 'q' 键，退出while循环")
                    running = False
                else:
                    # print("未找到目标元素，等待重试...")
                    time.sleep(0.5)  # 降低CPU占用
            except Exception as e:
                print(f"发生异常: {e}，尝试重新连接设备")                
                d = u2.connect(device_id) # 重新初始化设备连接
                time.sleep(2)
                
        return d
    
    except Exception as e:
        print(f"Connected failed: {str(e)}")
        sys.exit(1)

if __name__ == '__main__':
    signal.signal(signal.SIGINT, signal_handler)
    d = main()
