{ ... }: {
  programs.nushell = {
    enable = true;
    # 需要添加的路径在prepend中,而且多个添加中间用冒号隔开(:),添加另外命令用\n分隔
    extraEnv = "$env.PATH = ($env.PATH | prepend '/home/Sittymin/.bun/bin')";
    # extraConfig = ''load-env {
    #   # 设置 Rustup 镜像(字节跳动)
    #   "RUSTUP_DIST_SERVER": "https://rsproxy.cn"
    #   "RUSTUP_UPDATE_ROOT": "https://rsproxy.cn/rustup"
    #   }'';
  };
}
