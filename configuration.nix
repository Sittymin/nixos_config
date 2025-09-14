{
  ...
}:
{
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "24.11";

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "Sittymin"
      ];
      # NOTE: 在每次构建过程中对存储进行优化
      # PERF: 由nh的垃圾回收方式替代
      # auto-optimise-store = true;
      # 添加额外缓存
      substituters = [
        # "https://hyprland.cachix.org"
        # "https://cache.lix.systems"
        # "https://sittymin.cachix.org"
      ];
      trusted-public-keys = [
        # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        # "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        # "sittymin.cachix.org-1:GbIZbTYujtCGkvaoFL6cE6lvNvOpWNJgdcBNHXSDomw="
      ];
    };
    # NOTE:每周进行垃圾回收
    # PERF: 由nh的垃圾回收方式替代
    # WARN: 可能无用
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 1w";
    # };
    # NOTE:在使用了__noChroot = true的包中禁用沙盒
    # HACK:oneapi目前需要
    # extraOptions = ''sandbox = relaxed'';
  };

  nixpkgs.config = {
    # NOTE:允许非自由软件
    allowUnfree = true;
    # NOTE: 同意安卓许可
    # android_sdk.accept_license = true;
  };

  # 让 Qt 软件使用 gnome 的暗色外观
  # https://wiki.nixos.org/wiki/KDE#GNOME_desktop_integration
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  # NOTE:虚拟环境
  virtualisation = {
    waydroid.enable = true;
    docker = {
      enable = true;
      daemon.settings = {
        # Docker 占用的地址, 注意不要与通信的地址冲突
        bip = "192.168.3.1/24";
        # proxies = {
        #   http-proxy = "http://127.0.0.1:5353";
        #   https-proxy = "http://127.0.0.1:5353";
        # };
      };
    };
    # KVM
    libvirtd = {
      enable = true;
      qemu = {
        # TPM
        swtpm.enable = true;
        # UEFI | 好像是默认启用的
        ovmf.enable = true;
      };
    };
    # 启用USB重定向, 会将U盘重定向到虚拟机（主机会检测不到）
    # spiceUSBRedirection.enable = true;
    # 使用 sftp 吧
  };

  # 1. 创建新的 swap 文件，禁用 CoW (Btrfs 需要)
  # sudo touch /swapfile
  # sudo chattr +C /swapfile  # 禁用 Copy-on-Write

  # 2. 创建所需大小的 swap 文件
  # sudo dd if=/dev/zero of=/swapfile bs=1M count=8192

  # 3. 设置适当的权限
  # sudo chmod 600 /swapfile

  # 4. 格式化为 swap
  # sudo mkswap /swapfile

  # 5. 启用 swap
  # sudo swapon /swapfile

  # NOTE: 如果修改交换分区需要先禁用然后删除 swap 文件最后重新执行上面的步骤
  # swapDevices = [
  #   {
  #     device = "/swapfile";
  #     size = 8192; # 可选：指定大小（以 MiB 为单位）
  #   }
  # ];
  fileSystems = {
    "/mnt/CT1000MX500SSD1" = {
      device = "/dev/sda";
      fsType = "btrfs";
      options = [
        "defaults"
        "noatime"
        "nodiratime"
        "user=Sittymin"
      ];
    };
  };
}
