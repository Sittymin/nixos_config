{
  # 持久路径部分
  environment.persistence."/nix/persistent" = {
    # 不作为挂载磁盘显示
    hideMounts = true;
    # 映射目录
    directories = [
      # NM 连接信息
      "/etc/NetworkManager/system-connections"
      # 全局缓存
      "/var/cache"
      # 持久化 systemd 日志目录
      "/var/log/journal"
    ];
    # 映射文件
    files = [
      # SystemD 生成的机器ID，用于管理日志
      "/etc/machine-id"
    ];
    # 用户目录文件
    users.Sittymin = {
      directories = [
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"

        ".cache"
        ".gnupg"
        ".ssh"
      ];
      files = [ ];
    };
  };
  # 避免构建时在内存中
  systemd.services.nix-daemon = {
    environment = {
      # 指定临时文件的位置
      TMPDIR = "/var/cache/nix";
    };
    serviceConfig = {
      # 在 Nix Daemon 启动时自动创建 /var/cache/nix
      CacheDirectory = "nix";
    };
  };
  # 让 Root 用户也使用上面的构建文件临时位置
  environment.variables.NIX_REMOTE = "daemon";

  disko = {
    # 不要让 Disko 直接管理 NixOS 的 fileSystems.* 配置。
    # 原因是 Disko 默认通过 GPT 分区表的分区名挂载分区，但分区名很容易被 fdisk 等工具覆盖掉。
    # 导致一旦新配置部署失败，磁盘镜像自带的旧配置也无法正常启动。
    enableConfig = false;

    devices = {
      disk = {
        main = {
          type = "disk";
          # WARN: 磁盘设备名
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                # 优先级
                priority = 1;
                name = "ESP";
                start = "1M";
                end = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  # 修改权限，仅所有者可改动
                  mountOptions = [
                    "umask=0077"
                  ];
                };
              };
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted";
                  # disable settings.keyFile if you want to use interactive password entry
                  passwordFile = "/tmp/secret.key"; # 交互式
                  settings = {
                    # 启用 TRIM 命令。这有助于改善 SSD 的性能和寿命
                    allowDiscards = true;
                    # keyFile = "/tmp/secret.key"; # 非交互式
                  };
                  # 额外的自动读取解锁密码
                  # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];

                  # 存放 NixOS 系统的分区，使用剩下的所有空间。
                  content = {
                    type = "filesystem";
                    format = "btrfs";
                    # 格式化时直接覆盖
                    extraArgs = [ "-f" ];
                    # 用作 Nix 分区，Disko 生成磁盘镜像时根据此处配置挂载分区，需要和 fileSystems.* 一致
                    subvolumes = {
                      "/nix" = {
                        mountpoint = "/nix";
                        mountOptions = [
                          "compress=zstd"
                          "nosuid"
                          "nodev"
                        ];
                      };
                      # 持久化路径
                      "/persistent" = {
                        mountpoint = "/nix/persistent";
                        mountOptions = [
                          "compress=zstd"
                          "nosuid"
                          "nodev"
                        ];
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
  # 由于没有让 Disko 管理 fileSystems.* 配置，需要手动配置
  # 根分区 Impermanence 用 tmpfs
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      # relatime 优化
      "relatime"
      # 不能使用 777 不然 OpenSSH 拒绝使用
      "mode=755"
      "nosuid"
      "nodev"
      "size=16G"
    ];
  };

  # 需要与上面一致
  fileSystems."/nix" = {
    # 使用 LUKS 解密后设备名
    device = "/dev/mapper/crypted";
    fsType = "btrfs";
    # impermanence 模块强制要求
    neededForBoot = true;
    options = [
      # 子卷必须配置
      "subvol=nix"
      "compress=zstd"
      "nosuid"
      "nodev"
      "noatime"
      # SSD 优化
      "discard=async"
    ];
  };
  fileSystems."/nix/persistent" = {
    # 使用 LUKS 解密后设备名
    device = "/dev/mapper/crypted";
    fsType = "btrfs";
    # impermanence 模块强制要求
    neededForBoot = true;
    options = [
      # 子卷必须配置
      "subvol=persistent"
      "compress=zstd"
      "nosuid"
      "nodev"
      # SSD 优化
      "discard=async"
    ];
  };

  fileSystems."/boot" = {
    # WARN: 分区名(注意格式化后按需修改)
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
    options = [
      "umask=0077"
    ];
  };

  # 内存一部分空间使用压缩
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # 解锁 LUKS（必须）
  boot.initrd.luks.devices.crypted = {
    # 指向承载 Btrfs 的那块加密分区（推荐用 PARTUUID/UUID，而不是 /dev/nvme0n1p2 这类易变路径）
    device = "/dev/disk/by-partuuid/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
    allowDiscards = true; # 与你的需求一致
    # 交互式输入密码（常见做法）
    # 如需 keyfile 非交互式解锁，配合 boot.initrd.secrets 使用：
    # keyFile = "/keyfile.bin";
  };

  # 启用周期性 TRIM 以覆盖非 btrfs/vfat 等其他磁盘 SSD 优化
  services.fstrim.enable = true;
}
