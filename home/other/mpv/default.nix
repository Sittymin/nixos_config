{
  pkgs,
  # 似乎不可以直接用 inputs
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    svp
  ];
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      autoload
    ];
  };
  xdg.configFile = {
    "mpv" = {
      source = ./config;
      recursive = true;
    };
    "mpv/shaders" = {
      source = "${inputs.Anime4K}/glsl";
      recursive = true;
    };
    "mpv/scripts/thumbfast.lua" = {
      source = "${inputs.thumbfast}/thumbfast.lua";
    };
    "mpv/scripts/progressbar.lua" = {
      source = "${inputs.mpv-progressbar}/progressbar.lua";
    };
    "mpv/scripts/sub-fonts-dir-auto.lua" = {
      source = "${inputs.fbriere-mpv-scripts}/scripts/sub-fonts-dir-auto.lua";
    };
  };
}
