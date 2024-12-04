{
  ...
}:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "log-level-debug" = {
          "context.properties" = {
            "log.level" = "D";
          };
        };
        # 下面这一行是配置文件的名字
        "set-default-output" = {
          # 实际内容
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  # 波浪号表示后面是正则表达式
                  "node.name" = "~alsa_output.*hdmi-stereo*";
                }
              ];
              actions = {
                update-props = {
                  "node.description" = "显卡音频输出";
                  "priority.session" = "800";
                };
              };
            }
            {
              matches = [
                {
                  "node.name" = "~alsa_output.*iec958-stereo*";
                }
              ];
              actions = {
                update-props = {
                  # 禁用节点：无效，也许不是 wireplumber 控制的
                  # "device.disabled" = true;
                  "node.description" = "主板音频输出";
                  "priority.session" = "650";
                };
              };
            }
          ];
        };
        "always-use-a2dp" = {
          "monitor.bluez.rules" = [
            {
              matches = [
                {
                  ## 匹配所有蓝牙设备
                  device.name = "~bluez_card.*";
                }
              ];
              actions = {
                update-props = {
                  # 默认使用A2DP（不可使用麦克风）
                  bluez5.auto-connect = [ "a2dp_sink" ];
                  # 同步设备音量
                  bluez5.hw-volume = [ "a2dp_sink" ];
                  # sbc_xq 应该比 sbc 和 aac 要好 （不过还是不锁死了）
                  # api.bluez5.codec = "sbc_xq";
                };
              };
            }
          ];
          monitor.bluez.properties = {
            bluez5.roles = [ "a2dp_sink" ];
            # 避免切换到 HSP/HFP （虽然可以使用麦克风但是音质极差）
            bluez5.hfphsp-backend = "none";
          };
        };
      };
    };
  };
  # 为了让pipewire正常运行的一些东西
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
}
