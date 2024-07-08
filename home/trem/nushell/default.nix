{ ... }: {
  programs = {
    nushell = {
      enable = true;
      # 添加 Path
      extraConfig = ''
        $env.PATH = ($env.PATH | split row (char esep)
          | append ($env.HOME | path join .cargo bin) # 添加~/.cargo/bin
          | append ($env.BUN_INSTALL | path join bin)
          | uniq) # 去除重复路径
      '';
    };

    # 一个自动补全工具(实际上应该由 shell 提供)
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
