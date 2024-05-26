{ pkgs
, ...
}: {
  home.file = {
    ".config/helix/config.toml".source = ./config.toml;
    # NOTE: 配置 cargo 镜像(https://rsproxy.cn/)
    ".cargo/config".source = ./cargo_config;
  };
  programs.helix = {
    enable = true;

    extraPackages = with pkgs; [
      # 太老了
      nodePackages.volar
      # 使用bun -g i @vue/language-server
      # 且bun/bin目录包含在path
      nodePackages.vscode-langservers-extracted
      # 语言服务器
      rust-analyzer
      # 调试器
      lldb
      # Rust 格式化
      clippy
    ];
    languages = with pkgs; {
      language-server = {
        nil = {
          command = "${nil}/bin/nil";
          # config.nil = {
          #   formatting.command = [ "${nixpkgs-fmt}/bin/nixpkgs-fmt" ];
          #   # nix.flake.autoEvalInputs = true;
          # };
        };
        vuels = {
          command = "vue-language-server";
          args = [ "--stdio" ];
          config = {
            typescript = {
              # 为了让 vue 拥有自动补全
              # https://www.reddit.com/r/HelixEditor/comments/18o438c/comment/kek0aqm/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
              tsdk = "${nodePackages.typescript-language-server}/lib/node_modules/typescript/lib/";
            };
          };
        };
        # Format JS[X] TS[X] VUE JSON 
        # efm-lsp-prettier = {
        #   command = "${efm-langserver}/bin/efm-langserver";
        #   config = {
        #     documentFormatting = true;
        #     languages = lib.genAttrs [ "typescript" "javascript" "typescriptreact" "javascriptreact" "vue" "json" "markdown" ] (_: [{
        #       formatCommand = "${nodePackages.prettier}/bin/prettier --stdin-filepath \${INPUT}";
        #       formatStdin = true;
        #     }]);
        #   };
        # };
        eslint = {
          command = "vscode-eslint-language-server";
          args = [ "--stdio" ];
          config = {
            validate = "on";
            packageManager = "bun";
            useESLintClass = false;
            codeActionOnSave.mode = "all";
            # codeActionsOnSave = { mode = "all"; };
            format = true;
            quiet = false;
            onIgnoredFiles = "off";
            rulesCustomizations = [ ];
            run = "onType";
            # nodePath configures the directory in which the eslint server should start its node_modules resolution.
            # This path is relative to the workspace folder (root dir) of the server instance.
            nodePath = "";
            # use the workspace folder location or the file location (if no workspace folder is open) as the working directory

            workingDirectory.mode = "auto";
            experimental = { };
            problems.shortenToSingleLine = false;
            codeAction = {
              disableRuleComment = {
                enable = true;
                location = "separateLine";
              };
              showDocumentation.enable = true;
            };
          };
        };
        # https://discourse.nixos.org/t/helix-lsp-servers/34833/4
        rust-analyzer = {
          config.rust-analyzer = {
            cargo.loadOutDirsFromCheck = true;
            checkOnSave.command = "clippy";
            procMacro.enable = true;
            lens = { references = true; methodReferences = true; };
            completion.autoimport.enable = true;
            experimental.procAttrMacros = true;
          };
        };
      };
      language = [
        { name = "xml"; language-servers = [ "vscode-html-language-server" ]; }
        { name = "json"; language-servers = [{ name = "vscode-json-language-server"; except-features = [ "format" ]; }]; }
        { name = "html"; auto-format = false; }
        { name = "vue"; language-servers = [{ name = "vuels"; except-features = [ "format" ]; } "eslint"]; }
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
          file-types = [ "lalrpop" "rs" ];
          language-servers = [ "rust-analyzer" ];
        }
      ];
    };
  };
}
