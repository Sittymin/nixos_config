{ pkgs
, ...
}: {
  home = {
    file = {
      ".config/ironbar" = {
        source = ./config;
        recursive = true;
      };
    };
    packages = [
      pkgs.ironbar
    ];
  };
}
