{ pkgs
, ...
}: {

  boot = {
    # NOTE:对于Arc显卡的特殊设置
    initrd.kernelModules = [ "i915" ];
    # initrd.kernelModules = [ "xe" ];
    # kernelModules = [ "xe" "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    # NOTE:设置内核参数
    # 可能对于显卡驱动有帮助？
    kernelParams = [ "i915.force_probe=56a0" ];
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
}
