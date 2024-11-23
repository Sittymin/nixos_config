{ ...
}: {
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
                  "node.name" = "alsa_output.pci-0000_04_00.0.hdmi-stereo";
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
                  "node.name" = "alsa_output.pci-0000_00_1f.3.iec958-stereo";
                }
              ];
              actions = {
                update-props = {
                  "node.description" = "主板音频输出";
                  "priority.session" = "650";
                };
              };
            }
          ];
        };
      };
    };
  };
  # 为了让pipewire正常运行的一些东西
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
}
