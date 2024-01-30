{
  config,
  pkgs,
  ...
} : {
  home.file = {
    ".local" = {
      source = ./.local;
      recursive = true;
    };
    ".config" = {
      source = ./.config;
      recursive = true;
    };
  };
}
