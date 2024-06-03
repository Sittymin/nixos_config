{ pkgs
, ...
}: {
  # NOTE:设置系统服务
  services = {
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
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet -s -g NixOS-unstable --asterisks --user-menu -c 'niri-session'";
          # 以 greeter 用户的身份来执行
          user = "greeter";
        };
      };
    };
    openssh = {
      enable = true;
      settings = {
        # NOTE:允许X11转发
        X11Forwarding = true;
        PermitRootLogin = "no";
        # NOTE:禁止使用密码登录
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };
    flatpak = {
      enable = true;
    };
  };
}
