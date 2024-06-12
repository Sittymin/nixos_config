{ pkgs
, thumbfast
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
    ".config/mpv/scripts/thumbfast.lua" = {
      source = "${thumbfast}/thumbfast.lua";
    };
  };
}
