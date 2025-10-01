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
        # Ironbar
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        # "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        # "sittymin.cachix.org-1:GbIZbTYujtCGkvaoFL6cE6lvNvOpWNJgdcBNHXSDomw="
        # Ironbar
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
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
        # 告诉 Docker 使用固定的 DNS，这样它就不会去碰 /etc/resolv.conf
        # 即使网络还没就绪，也不会产生冲突
        "dns" = [
          "127.0.0.53"
          "192.168.47.1"
          "223.5.5.5"
        ];
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
}
