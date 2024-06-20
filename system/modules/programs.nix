{ pkgs
, ...
}: {
  programs = {
    steam = {
      enable = true;
      extraPackages = with pkgs; [
        # 也许只是让内部可以调用，外部必须再安装一个
        gamescope
      ];
      # fontPackages = with pkgs; [
      #   lxgw-neoxihei
      # ];
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
      config = {
        # 设置初始化的分支名位 main
        init.defaultBranch = "main";

        # 使用 difftastic 美化修改对比 (git difftool)
        diff.tool = "difftastic";
        difftool.prompt = false;
        # NOTE: 因为 NixOS 必须传入字符串 所以 difft "$LOCAL" "$REMOTE" 需要在最终配置加双引号的参数转义
        difftool.difftastic.cmd = "difft \"$LOCAL\" \"$REMOTE\"";
        pager.difftool = true;
        # 为 git difftool 添加别名 git dft
        alias.dft = "difftool";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    difftastic
  ];
}
