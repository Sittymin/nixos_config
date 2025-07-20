{
  pkgs,
  ...
}:
{
  # NOTE:设置系统语言为中文
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
    inputMethod = {
      enable = true;
      type = "fcitx5";
      # https://github.com/NixOS/nixpkgs/blame/master/nixos/modules/i18n/input-method/fcitx5.nix
      # 输入法的环境变量 https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
      # 配置了环境变量
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          # 修改以支持 emoji
          (fcitx5-rime.override {
            librime =
              (pkgs.librime.override {
                plugins = [
                  pkgs.librime-lua
                  pkgs.librime-octagram
                ];
              }).overrideAttrs
                (old: {
                  buildInputs = (old.buildInputs or [ ]) ++ [ luajit ];
                });
          })
          # 日语支持
          fcitx5-anthy
        ];
        # 文件会在 /etc/xdg/fcitx5
        settings = {
          # config
          globalOptions = {
            "Hotkey" = {
              # 切换启用/禁用输入法
              TriggerKeys = "";
              # 反复按切换键时进行轮换
              EnumerateWithTriggerKeys = "True";
              # 临时在当前和第一个输入法之间切换
              AltTriggerKeys = "";
              # 向前切换输入法
              EnumerateForwardKeys = "";
              # 轮换输入法时跳过第一个输入法
              EnumerateSkipFirst = "False";
              # 向前切换输入分组
              EnumerateGroupForwardKeys = "";
              # 激活输入法
              ActivateKeys = "";
              # 取消激活输入法
              DeactivateKeys = "";
              # 默认上一页
              PrevPage = "";
              # 默认下一页
              NextPage = "";
              # 默认跳转前一个候选词
              PrevCandidate = "";
              # 默认跳转下一个候选词
              NextCandidate = "";
              # 切换是否使用嵌入预编辑
              TogglePreedit = "";
            };
            "Hotkey/EnumerateBackwardKeys" = {
              "0" = "Super+space";
            };
            "Hotkey/EnumerateGroupBackwardKeys" = {
              "0" = "Super+G";
            };
            "Behavior" = {
              # 默认状态为激活
              ActiveByDefault = "False";
              # 重新聚焦时重置状态
              resetStateWhenFocusIn = "No";
              # 共享输入状态
              ShareInputState = "No";
              # 在程序中显示预编辑文本
              PreeditEnabledByDefault = "False";
              # 切换输入法时显示输入法信息
              ShowInputMethodInformation = "True";
              # 在焦点更改时显示输入法信息
              showInputMethodInformationWhenFocusIn = "True";
              # 显示紧凑的输入法信息
              CompactInputMethodInformation = "True";
              # 显示第一个输入法的信息
              ShowFirstInputMethodInformation = "True";
              # 默认页大小
              DefaultPageSize = "5";
              # 覆盖 Xkb 选项
              OverrideXkbOption = "False";
              # 自定义 Xkb 选项
              CustomXkbOption = "";
              # Force Enabled Addons
              EnabledAddons = "";
              # Force Disabled Addons
              DisabledAddons = "";
              # Preload input method to be used by default
              PreloadInputMethod = "True";
              # 允许在密码框中使用输入法
              AllowInputMethodForPassword = "False";
              # 输入密码时显示预编辑文本
              ShowPreeditForPassword = "False";
              # 保存用户数据的时间间隔（以分钟为单位）
              AutoSavePeriod = "30";
            };
          };
          # profile
          inputMethod = {
            "Groups/0" = {
              Name = "默认";
              # Layout
              "Default Layout" = "us";
              # Default Input Method
              DefaultIM = "rime";
            };
            "Groups/0/Items/0" = {
              Name = "keyboard-us";
            };
            "Groups/0/Items/1" = {
              Name = "rime";
            };
            "Groups/1" = {
              Name = "日语";
              "Default Layout" = "us";
              "DefaultIM" = "anthy";
            };
            "Groups/1/Items/0" = {
              Name = "anthy";
            };
            "GroupOrder" = {
              "0" = "默认";
              "1" = "日语";
            };
          };
          addons = {
            "classicui" = {
              globalSection = {
                # 垂直候选列表
                "Vertical Candidate List" = "True";
                # 使用鼠标滚轮翻页
                WheelForPaging = "True";
                # 字体
                Font = "LXGW Neo XiHei 13";
                # 菜单字体
                MenuFont = "LXGW Neo XiHei 10";
                # 托盘字体
                TrayFont = "LXGW Neo XiHei 10";
                # 托盘标签轮廓颜色
                TrayOutlineColor = "#000000";
                # 托盘标签文本颜色
                TrayTextColor = "#ffffff";
                # 优先使用文字图标 不启用时必须存在输入法的图标
                # 不然就是空的
                PreferTextIcon = "False";
                # 在图标中显示布局名称
                ShowLayoutNameInIcon = "True";
                # 使用输入法的语言来显示文字
                UseInputMethodLanguageToDisplayText = "True";
                # 主题
                Theme = "Mellow Graphite dark";
                # 深色主题
                DarkTheme = "Mellow Graphite dark";
                # 跟随系统浅色/深色设置
                UseDarkTheme = "False";
                # 当被主题和桌面支持时使用系统的重点色
                UseAccentColor = "False";
                # 在 X11 上针对不同屏幕使用单独的 DPI
                PerScreenDPI = "False";
                # 固定 Wayland 的字体 DPI
                ForceWaylandDPI = "0";
                # 在 Wayland 下启用分数缩放
                EnableFractionalScale = "True";
              };
            };
            "clipboard" = {
              globalSection = {
                # 粘贴主选区
                PastePrimaryKey = "";
                # 项目个数
                "Number of entries" = "5";
                # 不要显示密码管理工具中的密码
                IgnorePasswordFromPasswordManager = "False";
                # 隐藏剪贴板中包含密码的内容
                ShowPassword = "False";
                # 自动清除密码的秒数
                ClearPasswordAfter = 30;
              };
              sections = {
                TriggerKey = {
                  "0" = "Super+V";
                };
              };
            };
            "quickphrase" = {
              globalSection = {
                # 触发键
                TriggerKey = "";
                # 选词修饰键
                "Choose Modifier" = "None";
                # 启用拼写检查
                Spell = "False";
                # 备选拼写检查语言
                "FallbackSpellLanguage" = "en";
              };
            };
            "rime" = {
              globalSection = {
                # 预编辑模式(单行模式)
                PreeditMode = "Do not show";
                # 共享输入状态
                InputState = "Program";
                # 将嵌入式预编辑文本的光标固定在开头
                PreeditCursorPositionAtBeginning = "True";
                # 切换输入法时的行为
                SwitchInputMethodBehavior = "Clear";
                # 重新部署
                Deploy = "";
                # 同步
                Synchronize = "";
              };
            };
            # 生成INI https://github.com/NixOS/nixpkgs/pull/286399
            # "不带后缀文件名" = {
            #   # 顶级内容
            #   globalSection = {
            #      内容
            #   };
            #   # 非顶级内容
            #   sections = {
            #     ini节的名字 = {
            #       内容
            #     };
            #   };
            # };
          };
        };
      };
    };
  };

  # NOTE:设置时区
  time.timeZone = "Asia/Shanghai";
}
