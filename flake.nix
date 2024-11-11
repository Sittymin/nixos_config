{
  description = "Sittymin's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-e0464e4.url = "github:NixOS/nixpkgs/e0464e47880a69896f0fb1810f00e0de469f770a";
    # git 版本的软件
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # 安全启动
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      # 可选，但是注意限制系统软件数量
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };

    nur = {
      url = "github:nix-community/NUR";
    };

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    # TODO: 可滚动的平铺 Wayland 合成器
    niri.url = "github:sodiboo/niri-flake";

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

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

    # daeuniverse.url = "github:daeuniverse/flake.nix/unstable";

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
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
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
          inputs.lanzaboote.nixosModules.lanzaboote
          ({ pkgs, lib, ... }: {

            environment.systemPackages = [
              # For debugging and troubleshooting Secure Boot.
              pkgs.sbctl
            ];

            # Lanzaboote currently replaces the systemd-boot module.
            # This setting is usually set to true in configuration.nix
            # generated at installation time. So we force it to false
            # for now.
            boot.loader.systemd-boot.enable = lib.mkForce false;

            boot.lanzaboote = {
              enable = true;
              pkiBundle = "/etc/secureboot";
            };
          })

          inputs.lix-module.nixosModules.default
          inputs.nur.nixosModules.nur
          inputs.chaotic.nixosModules.default
          # inputs.daeuniverse.nixosModules.dae
          inputs.nix-index-database.nixosModules.nix-index
          inputs.niri.nixosModules.niri
          ({ config, pkgs, ... }:
            {
              # 使用我的NUR
              # 使用方法pkgs.myRepo.example-package
              nixpkgs.overlays = [
                (final: prev: {
                  myRepo = inputs.myRepo.packages."${prev.system}";
                })
              ];
              # 允许的过时软件
              nixpkgs.config.permittedInsecurePackages = [
                # xddxdd.baidunetdisk
                "electron-11.5.0"
              ];
              environment.systemPackages = (with config.nur.repos; [
                # NOTE:主要用于给waydroid提供转译层
                # 使用方法https://www.reddit.com/r/NixOS/comments/15k2jxc/need_help_with_activating_libhoudini_for_waydroid/
                ataraxiasjel.waydroid-script

                sigprof.firefox-langpack-zh-CN

                xddxdd.baidunetdisk
              ]) ++
              (with pkgs; [
                # Waydroid 蔚蓝档案脚本修复需要
                unixtools.xxd
                myRepo.xwayland-satellite
                myRepo.reqable
                # markdown 编辑器
                myRepo.apostrophe-2-6-3
                # chromiun 内核浏览器
                # myRepo.thorium
              ]);
            })
          home-manager.nixosModules.home-manager
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
