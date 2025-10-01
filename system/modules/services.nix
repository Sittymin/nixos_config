{
  pkgs,
  ...
}:
{
  # NOTE:设置系统服务
  services = {
    # 限制日志大小
    journald.extraConfig = "SystemMaxUse=10M";
    # NOTE: Btrfs自动清理
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [ "/" ];
    };
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet -s -g NixOS-unstable --asterisks --user-menu -c 'niri-session'";
          # 以 greeter 用户的身份来执行
          user = "greeter";
        };
      };
    };
    # 这里是 SSH server
    openssh = {
      enable = true;
      settings = {
        # NOTE:允许X11转发
        X11Forwarding = true;
        PermitRootLogin = "no";
        # NOTE:禁止使用密码登录
        PasswordAuthentication = false;
        # 允许使用密钥
        PubkeyAuthentication = true;
      };
      openFirewall = true;
    };
    flatpak = {
      enable = true;
      # remotes = {
      #   "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      # };
      # packages = [
      #   "flathub:app/com.tencent.WeChat/x86_64/stable"
      #   "flathub:app/com.bambulab.BambuStudio/x86_64/stable"
      # ];
    };
    # 自动挂载与管理U盘
    # 挂载位置在 /run/media
    udisks2.enable = true;
    # 是一个Gnome提供的文件系统抽象层（显示 MTP 或网络设备）
    # 挂载位置在 /run/user/1000/gvfs
    gvfs.enable = true;
    # 为了可以直连 fastboot, 下面是指定手机制造商
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="users"
    '';
    # GNOME Network Displays 用来发现网络上的设备
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    # 数据库
    # postgresql = {
    # enable = true;
    # dataDir = "";
    # 默认位置是
    # /var/lib/postgresql/${config.services.postgresql.package.psqlSchema}
    # };
    nginx = {
      enable = false;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # 注意修改为自己IP
      # 修改为未明确处理的请求就到这
      virtualHosts."_" = {
        enableACME = false; # 不使用ACME，因为我们使用自签名证书
        forceSSL = true;
        # 似乎home目录对它不可访问
        sslCertificate = "/etc/ssl/fullchain.pem";
        sslCertificateKey = "/etc/ssl/privkey.pem";

        locations."/" = {
          # 代理的地址
          proxyPass = "http://127.0.0.1:5757";
          proxyWebsockets = true; # 如果需要使用WebSocket
        };
        locations."/api" = {
          proxyPass = "http://127.0.0.1:5858";
          proxyWebsockets = true;
          extraConfig = ''
            rewrite ^/api/(.*) /$1 break;  # 去除 /api 前缀
          '';
        };
      };
    };
    # 应用软件开发部分
    # mysql = {
    #   enable = true;
    #   package = pkgs.mariadb;
    #   settings = {
    #     mysqld = {
    #       port = "2000";
    #       lower_case_table_names = 1; # 设置表名大小写不敏感
    #     };
    #   };
    # };
    # redis.servers."temp1" = {
    #   enable = true;
    #   port = 6379;
    # };
  };
}
