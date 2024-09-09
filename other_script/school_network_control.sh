#!/bin/sh
while true; do
    # 获取当前的小时和星期
    hour=$(date +"%H")
    day=$(date +"%u")

    if [[ $day == 7 || ($day -ge 1 && $day -le 4) ]]; then
        echo "✔️ 星期天到星期四"
        if [[ $hour -ge 23 || $hour -lt 7 ]]; then
            echo "✔️ 23:00 - 07:00"
            # 确保WiFi适配器已启用
            nmcli radio wifi on
            # 检查是否已连接到指定的WiFi
            if ! nmcli -t -f active,ssid dev wifi | grep -q '^是:XiaoMi 13 Pro$'; then
                # 执行一次WiFi扫描
                nmcli device wifi rescan
                # 等待一小段时间让扫描完成
                sleep 10
                # 尝试连接到指定的WiFi
                nmcli dev wifi connect 'XiaoMi 13 Pro' password '66666666'
            fi
            # 再次检查WiFi是否成功连接并且是活跃的
            if nmcli -t -f active,ssid dev wifi | grep -q '^是:XiaoMi 13 Pro$'; then
                echo "✔️ 尝试连接到手机热点"
                # 检查enp7s0是否活跃
                if nmcli -t -f device,state dev status | grep -q '^enp7s0:connected$'; then
                    nmcli dev disconnect enp7s0
                fi
            fi
        else
            echo "❌ 23:00 - 07:00"
            # 检查enp7s0是否已经连接
            if ! nmcli -t -f device,state dev status | grep -q '^enp7s0:connected$'; then
                nmcli dev connect enp7s0
            fi
        fi
    else
        echo "❌ 星期天到星期四"
        # 检查enp7s0是否已经连接
        if ! nmcli -t -f device,state dev status | grep -q '^enp7s0:connected$'; then
            nmcli dev connect enp7s0
        fi
    fi
    # 每分钟检查一次
    echo "-----------------------"
    sleep 60
done
