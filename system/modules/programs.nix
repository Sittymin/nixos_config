{
  pkgs,
  # inputs,
  ...
}:
let
  steamFonts = pkgs.symlinkJoin {
    name = "steam-fonts";
    paths = with pkgs; [
      wqy_zenhei
      wqy_microhei
      # 微软的一些字体
      corefonts
      vistafonts
      vistafonts-chs
    ];
  };
in
{
  programs = {
    # DRM 通过 Gamescope 启动
    # https://github.com/ValveSoftware/steam-for-linux/issues/9495#issuecomment-2356994370
    # 在控制台中输入 quit 退出
    # https://github.com/ValveSoftware/gamescope/issues/645#issuecomment-1366906908
    # -O 选择输出显示器
    # 大小为 4K 指定DP-2输出 嵌入Steam 全屏 大屏幕模式 开启控制台
    # gamescope -W 3820 -H 2160 -O DP-2 -e -f -- steam -tenfoot -console
    steam = {
      enable = true;
      # gamescopeSession.enable = true;
      # 在一些 Xwayland 实现中 Steam 使用 GPU 渲染网页应该关掉
      # extraPackages = with pkgs; [
      # 也许只是让内部可以调用，外部必须再安装一个
      # gamemode
      # ];
      fontPackages = [ steamFonts ];
      # 是否启用将 extest 库加载到 Steam 中，以将 X11 输入事件转换为 uinput 事件（例如，在 Wayland 上使用 Steam 输入）
      extest.enable = true;
      package = pkgs.steam.override {
        # 传入 Steam 的环境变量
        # extraEnv = { STEAM_FORCE_DESKTOPUI_SCALING = "1.5"; };
        # extraLibraries = pkgs: [ pkgs.xorg.libxcb ];
      };
      # 其他兼容层
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };

    # NOTE:KVM
    virt-manager.enable = true;

    # PERF: nh NixOS 模块提供了一种垃圾回收方式，可替代默认的垃圾回收方式
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
    };

    git = {
      enable = true;
      lfs.enable = true;
      config = {
        # 设置初始化的分支名位 main
        init.defaultBranch = "main";

        # 使用 kitty 美化修改对比
        diff = {
          tool = "kitty";
          guitool = "kitty.gui";
        };
        difftool = {
          prompt = false;
          trustExitCode = true;
        };
        difftool.kitty.cmd = "kitten diff $LOCAL $REMOTE";
        difftool."kitty.gui".cmd = "kitten diff $LOCAL $REMOTE";
        # 添加使用 kitten 查看差异别名 git dft
        alias.dft = "difftool --no-symlinks --dir-diff";

        # 设置Git使用GPG签名( HomeManager 代替，毕竟定义用户的不再全局)
        # user.signingkey = "747FDF0404DC5B77";
        # commit.gpgsign = true;
      };
    };
    # GPG 密钥对加密与解密
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-tty;
    };
    wireshark = {
      enable = false;
      package = pkgs.wireshark;
    };
    # 咱不需要 nano (它默认开启)
    nano.enable = false;

    alvr = {
      enable = false;
      openFirewall = true;
    };
  };
}
