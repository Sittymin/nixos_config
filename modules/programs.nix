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
  };
}
