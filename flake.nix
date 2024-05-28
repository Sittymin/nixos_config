{
  description = "Sittymin's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    lix = {
      url = "git+https://git.lix.systems/lix-project/lix?ref=refs/tags/2.90-beta.1";
      flake = false;
    };
    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
    };

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    # TODO: 可滚动的平铺 Wayland 合成器
    niri.url = "github:sodiboo/niri-flake";

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    rime-dicts = {
      url = "github:iDvel/rime-ice";
      flake = false;
    };

    # mpv 的缩略图生成
    thumbfast = {
      url = "github:po5/thumbfast";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, nur, lix-module, niri, ... }@inputs: {
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit inputs; };


        modules = [
          ./configuration.nix
          ./overlay
          lix-module.nixosModules.default
          nur.nixosModules.nur

          niri.nixosModules.niri
          ({ config, pkgs, ... }:
            {
              environment.systemPackages = [
                # NOTE:主要用于给waydroid提供转译层
                # 使用方法https://www.reddit.com/r/NixOS/comments/15k2jxc/need_help_with_activating_libhoudini_for_waydroid/
                config.nur.repos.ataraxiasjel.waydroid-script
                config.nur.repos.sigprof.firefox-langpack-zh-CN
              ];
            })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.Sittymin = import ./home;

            # NOTE:使用 home-manager.extraSpecialArgs 自定义传递给 ./home.nix 的参数
            # 取消注释下面这一行，就可以在 home.nix 中使用 flake 的所有 inputs 参数了
            home-manager.extraSpecialArgs = inputs;
          }
        ];
      };
    };
  };
}
