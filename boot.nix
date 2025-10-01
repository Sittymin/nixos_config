{
  pkgs,
  config,
  ...
}:
{

  boot = {
    # NOTE:对于Arc显卡的特殊设置
    # initrd.kernelModules = [ "i915" ];
    initrd.kernelModules = [
      "xe"
      "i915"
      "vfio-pci"
    ];
    # NOTE:设置内核参数
    # 强制i915不要探测显卡设备ID,xe驱动程序探测显卡设备ID
    # kernelParams = [ "i915.force_probe=56a0" "xe.force_probe=!56a0" ];
    kernelParams = [
      # "i915.force_probe=!56a0"
      # "xe.force_probe=56a0"
      "intel_iommu=on"
      "iommu=pt"
    ];
    kernel.sysctl = {
      # 提升网络质量
      # 公平地调度网络流量，减少延迟并提高整体网络性能
      "net.core.default_qdisc" = "fq";
      # 提高高延迟网络的传输效率
      "net.ipv4.tcp_window_scaling" = "1";
      # 降低延迟
      "net.ipv4.tcp_low_latency" = "1";
      # 有助于 RTT（往返时间）估算，提高网络性能
      "net.ipv4.tcp_timestamps" = "1";
      # 提高数据传输效率
      "net.ipv4.tcp_sack" = "1";
      # 减少连接建立时间
      "net.ipv4.tcp_fastopen" = "3";
      # 更有效地利用带宽和减少延迟
      "net.ipv4.tcp_congestion_control" = "bbr";
      # 关闭 docker0 的 send_redirects（避免 ICMP 请求绕过透明代理）
      "net.ipv4.conf.docker0.send_redirects" = 0;

      # 开启 docker0 的 IPv6 forwarding（如果需要 IPv6）
      "net.ipv6.conf.docker0.forwarding" = 1;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    # 会花屏
    # kernelPackages = pkgs.linuxPackages_latest-libre;
    # OBS 虚拟摄像头
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    # 配置 v4l2loopback 虚拟摄像头
    # 配置无线监管域（对于 Intel 的傻逼网卡没有用）
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      options cfg80211 ieee80211_regdom=CN
    '';
    loader = {
      # NOTE:引导最多为10个配置文件
      systemd-boot.configurationLimit = 10;
      # NOTE:允许GRUB修改EFI变量
      efi.canTouchEfiVariables = true;
      # NOTE:启用systemd-boot引导
      systemd-boot.enable = true;
    };
    # NOTE: 启用嵌套虚拟化
    # NOTE: 不模拟无效的客户机状态
    # NOTE: 忽略模型特定的寄存器（MSRs）
    # extraModprobeConfig = ''
    #   options kvm_intel nested=1
    #   options kvm_intel emulate_invalid_guest_state=0
    #   options kvm ignore_msrs=1
    # '';
  };
  # OBS 虚拟摄像头
  security.polkit.enable = true;
}
