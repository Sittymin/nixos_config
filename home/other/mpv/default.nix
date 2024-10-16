{ pkgs
  # 似乎不可以直接用 inputs
, inputs
  # , thumbfast
  # , mpv-progressbar
  # , fbriere-mpv-scripts
  # , Anime4K
, ...
}: {
  home.packages = with pkgs; [
    svp
  ];
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      autoload
    ];
  };
  home.file = {
    ".config/mpv" = {
      source = ./config;
      recursive = true;
    };
    ".config/mpv/shaders" = {
      source = "${inputs.Anime4K}/glsl";
      recursive = true;
    };
    ".config/mpv/scripts/thumbfast.lua" = {
      source = "${inputs.thumbfast}/thumbfast.lua";
    };
    ".config/mpv/scripts/progressbar.lua" = {
      source = "${inputs.mpv-progressbar}/progressbar.lua";
    };
    ".config/mpv/scripts/sub-fonts-dir-auto.lua" = {
      source = "${inputs.fbriere-mpv-scripts}/scripts/sub-fonts-dir-auto.lua";
    };
  };
}
