{ ... }: {
  programs.nushell = {
    enable = true;
    # 添加 Path
    extraConfig = ''
      $env.PATH = ($env.PATH | split row (char esep)
        | append ($env.HOME | path join .cargo bin) # 添加~/.cargo/bin
        | uniq) # 去除重复路径
    '';
  };
}
