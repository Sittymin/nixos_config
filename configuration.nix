{ ...
}: {
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "24.05";

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "Sittymin" ];
      # NOTE: 在每次构建过程中对存储进行优化
      # PERF: 由nh的垃圾回收方式替代
      # auto-optimise-store = true;
      # 添加额外缓存
      substituters = [
        "https://hyprland.cachix.org"
        "https://cache.lix.systems"
        "https://anyrun.cachix.org"
        "https://sittymin.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "sittymin.cachix.org-1:GbIZbTYujtCGkvaoFL6cE6lvNvOpWNJgdcBNHXSDomw="
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

  # NOTE:允许非自由软件
  nixpkgs.config.allowUnfree = true;

  # NOTE:虚拟环境 
  virtualisation = {
    waydroid.enable = true;
    docker.enable = true;
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
    spiceUSBRedirection.enable = true;
  };

  fileSystems = {
    "/mnt/CT1000MX500SSD1" = {
      device = "/dev/sda";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "nodiratime" "user=Sittymin" ];
    };
  };
}
