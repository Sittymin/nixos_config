{
  description = "Sittymin's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-e0464e4.url = "github:NixOS/nixpkgs/e0464e47880a69896f0fb1810f00e0de469f770a";
    nixpkgs-electron11.url = "github:NixOS/nixpkgs/nixos-23.11";
    # git 版本的软件
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # 安全启动
    # NOTE: 等重装系统全盘加密并且 ESP 分区较大时再说吧
    # lanzaboote = {
    # url = "github:nix-community/lanzaboote/v0.4.1";
    # 可选，但是注意限制系统软件数量
    # inputs.nixpkgs.follows = "nixpkgs";
    # };

    # nixd 不可以用 lix 构建
    # lix = {
    #   url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
    #   flake = false;
    # };
    # lix-module = {
    #   url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.lix.follows = "lix";
    # };

    nur = {
      url = "github:nix-community/NUR";
    };

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    # 可滚动的平铺 Wayland 合成器
    niri.url = "github:sodiboo/niri-flake";

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    # firefox-nightly.url = "github:nix-community/flake-firefox-nightly";
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    rime-dicts = {
      url = "github:iDvel/rime-ice";
      flake = false;
    };
    rime-double-pinyin = {
      url = "github:rime/rime-double-pinyin";
      flake = false;
    };

    # mpv 的缩略图生成
    thumbfast = {
      url = "github:po5/thumbfast";
      flake = false;
    };
    # mpv 底部进度条
    mpv-progressbar = {
      url = "github:torque/mpv-progressbar/build";
      flake = false;
    };
    # mpv 自动加载 Fonts 文件夹中的字体
    fbriere-mpv-scripts = {
      url = "github:fbriere/mpv-scripts";
      flake = false;
    };
    # Anime4K 为 mpv 动漫实时高清放大
    Anime4K = {
      url = "github:bloc97/Anime4K";
      flake = false;
    };

    # 桌面壁纸
    swww.url = "github:LGFae/swww";

    myRepo = {
      url = "github:Sittymin/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # 查找包含库的软件包
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # Yazi Theme
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    catppuccin-yazi = {
      url = "github:catppuccin/yazi";
      flake = false;
    };

    # Nushell 官方一些有用的代码（如一些命令的自动补全）
    nu-scripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
    };

    # helix 官方的 flake
    helix.url = "github:helix-editor/helix";

    # 另外一个终端
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    # 好看的 Fcitx5 主题
    # 不知道为啥不能使用 SVG 作为背景
    # fcitx5-mellow-themes = {
    #   url = "github:sanweiya/fcitx5-mellow-themes";
    #   flake = false;
    # };

    # daeuniverse.url = "github:daeuniverse/flake.nix/unstable";

    # mosdns 的匹配规则
    adsList = {
      url = "https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/reject-list.txt";
      flake = false;
    };
    proxyList = {
      url = "https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/proxy-list.txt";
      flake = false;
    };
    directList = {
      url = "https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/direct-list.txt";
      flake = false;
    };

    v2ray-geoip-dat = {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat";
      flake = false;
    };
    v2ray-geosite-dat = {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat";
      flake = false;
    };

    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      # nixd 自动补全选项的前提(好像默认就是启用的)
      nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      nixosConfigurations = {
        "nixos" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
            pkgs-e0464e4 = import inputs.nixpkgs-e0464e4 {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [
            # 相当于在configuration.nix
            (
              { pkgs, ... }:
              {
                # 为官方 pkgs 增加其他包
                nixpkgs.overlays = [
                  (final: prev: {
                    baidunetdisk = final.callPackage ./pkgs/baidunetdisk {
                    };
                    myRepo = inputs.myRepo.packages."${prev.system}";
                    electron_11 =
                      (import inputs.nixpkgs-electron11 {
                        system = prev.system;
                        config = {
                          allowUnfree = true;
                          permittedInsecurePackages = [ "electron-11.5.0" ];
                        };
                      }).electron_11;
                  })
                ];
                # 允许的过时软件
                nixpkgs.config.permittedInsecurePackages = [
                  # xddxdd.dingtalk
                  "openssl-1.1.1w"
                ];
                environment.systemPackages =
                  (with pkgs.nur.repos; [
                    # NOTE:主要用于给waydroid提供转译层
                    # 使用方法https://www.reddit.com/r/NixOS/comments/15k2jxc/need_help_with_activating_libhoudini_for_waydroid/
                    # ataraxiasjel.waydroid-script

                    xddxdd.dingtalk
                  ])
                  ++ (with pkgs; [
                    # Waydroid 蔚蓝档案脚本修复需要
                    # unixtools.xxd
                    myRepo.reqable
                    # myRepo.steel
                    baidunetdisk
                  ]);

              }
            )
            ./modules/mosdns
            ./configuration.nix
            ./overlay
            ./system/host
            ./system/config
            ./system/modules
            ./wallpaper

            # 配置分区
            inputs.disko.nixosModules.disko
            ./disk-config.nix

            # 安全启动部分
            # inputs.lanzaboote.nixosModules.lanzaboote
            # (
            #   { pkgs, lib, ... }:
            #   {

            #     environment.systemPackages = [
            #       # For debugging and troubleshooting Secure Boot.
            #       pkgs.sbctl
            #     ];

            #     # Lanzaboote currently replaces the systemd-boot module.
            #     # This setting is usually set to true in configuration.nix
            #     # generated at installation time. So we force it to false
            #     # for now.
            #     boot.loader.systemd-boot.enable = lib.mkForce false;

            #     boot.lanzaboote = {
            #       enable = true;
            #       pkiBundle = "/etc/secureboot";
            #     };
            #   }
            # )

            # inputs.lix-module.nixosModules.default
            inputs.nur.modules.nixos.default
            inputs.chaotic.nixosModules.default
            # inputs.daeuniverse.nixosModules.dae
            inputs.nix-index-database.nixosModules.nix-index
            inputs.niri.nixosModules.niri
            (
              { pkgs, ... }:
              {
              }
            )
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.Sittymin = import ./home;
              # 如果遇到重复文件为原始文件添加backup，而不是发生错误
              home-manager.backupFileExtension = "backup";

              # NOTE:使用 home-manager.extraSpecialArgs 自定义传递给 ./home.nix 的参数
              # 取消注释下面这一行，就可以在 home.nix 中使用 flake 的所有 inputs 参数了
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        };
      };
    };
}
