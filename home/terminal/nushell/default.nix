{ inputs, ... }:
{
  programs = {
    nushell = {
      enable = true;
      extraConfig = ''
        # 自定义自动补全
        use /etc/nixos/home/terminal/nushell/custom_completions.nu *
        # 社区一些自动补全
        source ${inputs.nu-scripts}/custom-completions/adb/adb-completions.nu
        source ${inputs.nu-scripts}/custom-completions/cargo/cargo-completions.nu
        source ${inputs.nu-scripts}/custom-completions/docker/docker-completions.nu
        source ${inputs.nu-scripts}/custom-completions/fastboot/fastboot-completions.nu
        source ${inputs.nu-scripts}/custom-completions/git/git-completions.nu
        source ${inputs.nu-scripts}/custom-completions/nix/nix-completions.nu
        source ${inputs.nu-scripts}/custom-completions/npm/npm-completions.nu
        source ${inputs.nu-scripts}/custom-completions/rustup/rustup-completions.nu
        source ${inputs.nu-scripts}/custom-completions/ssh/ssh-completions.nu
        source ${inputs.nu-scripts}/custom-completions/tar/tar-completions.nu
        # 使用主题（好像光标和输出会使用主题颜色）
        source ${inputs.nu-scripts}/themes/nu-themes/catppuccin-mocha.nu
        # 指定 nu 使用的编辑器
        $env.config.buffer_editor = 'hx'
      '';
      extraEnv = ''
        $env.CARGO_HOME = ($env.HOME | path join ".cargo")

        # 0.101 版本及以上推荐的 Path 配置
        use std/util "path add"
        path add ($env.BUN_INSTALL | path join "bin")
        path add ($env.CARGO_HOME | path join "bin")

        # 让 GPG 在 pinentry-tty 签名生效
        $env.GPG_TTY = (tty | str trim)

        # 启用 Kitty 键盘协议
        $env.config.use_kitty_protocol = true

        # 以便可以使用 sudo -E wireshark 使用图形界面(-E 为使用环境变量)
        $env.XDG_RUNTIME_DIR = "/run/user/1000"
      '';
    };
  };
}
