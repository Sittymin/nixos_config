{ pkgs
, mpv-lua
, thumbfast
, ...
}: {
  home.packages = with pkgs; [
    mpv
  ];
  home.file = {
    ".config/mpv" = {
      source = ./config;
      recursive = true;
    };
    ".config/mpv/scripts/autoload.lua" = {
      source = "${mpv-lua}/TOOLS/lua/autoload.lua";
    };
    ".config/mpv/scripts/stats.lua" = {
      source = "${mpv-lua}/player/lua/stats.lua";
    };
    ".config/mpv/scripts/thumbfast.lua" = {
      source = "${thumbfast}/thumbfast.lua";
    };
  };
}
