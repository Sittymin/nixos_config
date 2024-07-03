{ pkgs
, ...
}: {
  home.file = {
    ".config/helix/config.toml".source = ./config.toml;
    # NOTE: 配置 cargo 镜像(https://rsproxy.cn/)
    ".cargo/config.toml".source = ./cargo_config.toml;
    # 利用 Zellij 让 yazi 成为 Helix 的文件选择器
    ".config/helix/yazi-picker.sh".source = ./yazi-picker.sh;
  };
  programs.helix = {
    enable = true;

    languages = with pkgs; {
      language-server = {
        nil = {
          command = "${nil}/bin/nil";
        };
        vuels = {
          command = "${vue-language-server}/bin/vue-language-server";
          config = {
            typescript = {
              # 似乎默认找不到
              tsdk = "${nodePackages.typescript-language-server}/lib/node_modules/typescript/lib/";
            };
          };
        };
        # 以下链接为生效的最小配置
        # https://github.com/helix-editor/helix/discussions/10171#discussioncomment-9027190
        # 依赖于项目 Eslint 设置 (需要使用较新的 eslint.config.js 配置，而不是.eslintrc.*)
        vscode-eslint-language-server = {
          command = "${vscode-langservers-extracted}/bin/vscode-eslint-language-server";
          args = [ "--stdio" ];
          config = {
            # 启用验证
            validate = "on";
            # 较新的 Eslint 似乎是默认启用的
            experimental = { useFlatConfig = true; };
            rulesCustomizations = [
              # 自定义规则(只可以修改警告等级, 详细配置只可以在项目 eslint.config.js 配置)
              {
                # 自闭合规则
                # https://eslint.vuejs.org/rules/html-self-closing
                # 需要在项目中修改以适配 prettier
                "rule" = "vue/html-self-closing";
                "severity" = "error";
              }
            ];
            # 输入时运行
            run = "onType";
            # 不缩短问题描述为单行
            problems = { shortenToSingleLine = false; };
            nodePath = "";
            # 自动格式化
            # 在合并 https://github.com/helix-editor/helix/pull/6486 之前不起作用
            # format = { enable = true; };
            # codeActionsOnSave = { mode = "all"; "source.fixAll.eslint" = true; };
          };
        };
        rust-analyzer = {
          command = "${rust-analyzer-unwrapped}/bin/rust-analyzer";
          # 未测试用途
          check.command = "${clippy}/bin/cargo-clippy";
        };
      };
      language = [
        {
          name = "vue";
          # 注释相关
          # https://github.com/helix-editor/helix/issues/7364
          # 自动格式化
          auto-format = true;
          formatter =
            {
              command = "${nodePackages_latest.prettier}/bin/prettier";
              args = [ "--parser" "vue" ];
            };
          language-servers = [
            "vuels"
            "vscode-eslint-language-server"
          ];
        }
        {
          name = "nix";
          language-servers = [ "nil" ];
          auto-format = true;
          formatter = {
            command = "${nixpkgs-fmt}/bin/nixpkgs-fmt";
          };
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = [ "rust-analyzer" ];
        }
      ];
    };
  };
}
