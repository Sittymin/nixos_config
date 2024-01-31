{
  config,
  pkgs,
  ...
} : {
  home.file = {
    ".config/waybar" = {
      source = ./.config/waybar;
      recursive = true;
    };
  };
}
