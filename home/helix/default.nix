{ pkgs
, ...
}: {
  # home.file = { ".config/helix/config.toml".source = ./config.toml; };
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        line-number = "relative";
        cursorline = true;
        cursorcolumn = true;
        bufferline = "multiple";
        # 用于控制弹出窗口（如自动完成、提示等）周围是否显示边框
        popup-border = "all";
        auto-completion = true;
      };
      editor.statusline = {
        left = [ "mode" "spinner" ];
        center = [ "file-name" "read-only-indicator" "file-modification-indicator" ];
        right = [ "diagnostics" "selections" "position" "file-encoding" "file-type" ];
        # 用于在状态栏中分隔元素的字符
        separator = "│";
        mode.normal = "普通模式";
        mode.insert = "插入模式";
        mode.select = "选择模式";
      };
      editor.lsp = {
        # 在状态行显示 LSP 进度消息
        display-messages = true;
        # 显示嵌入提示
        display-inlay-hints = true;
      };
      editor.cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };

      editor.file-picker = {
        # 启用忽略隐藏文件
        hidden = false;
      };
      # 使用可见字符渲染空格的选项
      editor.whitespace.render = {
        space = "all";
        tab = "all";
        nbsp = "none";
        nnbsp = "none";
        newline = "none";
      };
      editor.whitespace.characters = {
        space = "·";
        tab = "→";
        newline = "";
        tabpad = "·"; # Tabs will look like "→···" (depending on tab width)
      };
      # 使用软换行
      editor.soft-wrap = {
        enable = true;
        # 软折行时，行尾可以留下的最大空闲空间;
        max-wrap = 25;
        # 在软折行时，可以保留的最大缩进量;
        max-indent-retain = 40;
        # 在软换行的行之前插入的文本;
        wrap-indicator = "󱞩";
      };
      keys.normal = {
        # Ctrl + s 保存;
        C-s = ":w";
        # 下一个缓冲区;
        tab = ":bn";
        # 上一个缓冲区;
        S-tab = ":bp";
        # 将当前行向上移动;
        S-k = [ "extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before" ];
        # 将当前行向下移动;
        S-j = [ "extend_to_line_bounds" "delete_selection" "paste_after" ];
        # 将当前选择向左移(会换行);
        S-h = [ "delete_selection" "move_char_left" "paste_before" ];
        # 将当前选择向右移(会换行);
        S-l = [ "delete_selection" "paste_after" ];
      };
      keys.insert = {
        j = { k = "normal_mode"; };
      };
      keys.select = {
        # 将当前选择向左移(会换行)
        S-h = [ "delete_selection" "move_char_left" "paste_before" "select_mode" ];
        # 将当前选择向右移(会换行)
        S-l = [ "delete_selection" "paste_after" "select_mode" ];
      };
    };


    extraPackages = with pkgs; [
      # 太老了
      nodePackages.volar
      # 使用bun -g i @vue/language-server
      # 且bun/bin目录包含在path
      nodePackages.vscode-langservers-extracted
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
      ];
    };
  };
}
