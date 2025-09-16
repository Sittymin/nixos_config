{
  # WARN: 新路径由于需要创建映射路径，所以会被覆盖为空
  # WARN: 记得备份放到映射过来的路径
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
      # 用户映射信息
      "/var/lib/nixos"
      # 持久化 systemd 日志目录
      "/var/log/journal"
      # 安全启动密钥存放地
      "/var/lib/sbctl"
    ];
    # 映射文件
    files = [
      # SystemD 生成的机器ID，用于管理日志
      "/etc/machine-id"
    ];
    # 用户目录文件
    users.Sittymin = {
      directories = [
        "nixos_config"

        "Development"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Public"
        "Videos"

        "StaticDoNotUpload"

        ".cache"
        ".gnupg"
        ".ssh"

        # 火狐浏览器数据
        ".mozilla"
        # Steam 文件数据
        ".local/share/Steam"
        # Steam 客户端设置
        ".steam"

        # Rime 同步文件夹
        ".local/share/fcitx5/rime/sync"
        # Syncthing 同步软件设置的文件夹
        ".local/state/syncthing"
        # yazi 插件
        ".config/yazi/plugins"
        # flatpak 数据 (NOTE: 全局的安装会重启时删除)
        ## 每个 Flatpak 应用的用户数据
        ".var/app"
      ];
      files = [
        # Rime 的安装信息（不可以 NixOS 配置来生成）
        # WARN: 当中的 installation_id 是用于同步的文件夹名
        ".local/share/fcitx5/rime/installation.yaml"
        # nushell 历史命令
        ".config/nushell/history.txt"
        # yazi 插件信息
        ".config/yazi/package.toml"
      ];
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
                    type = "btrfs";
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
    device = "/dev/disk/by-partuuid/5149c07a-3539-4087-9a81-190476aa0253";
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
    # 指向承载 Btrfs 的那块加密分区
    device = "/dev/disk/by-partuuid/df92d26d-1b91-4807-bf33-d57032e74381";
    allowDiscards = true; # 与disko的配置一致
    # 交互式输入密码（常见做法）
    # 如需 keyfile 非交互式解锁，配合 boot.initrd.secrets 使用：
    # keyFile = "/keyfile.bin";
  };

  # 启用周期性 TRIM 以覆盖非 btrfs/vfat 等其他磁盘 SSD 优化
  services.fstrim.enable = true;
}
