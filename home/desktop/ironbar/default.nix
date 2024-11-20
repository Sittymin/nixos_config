{ pkgs
, ...
}: {
  xdg.configFile."ironbar" = {
    source = ./config;
    recursive = true;
  };
  home = {
    # file = {
    #   ".config/ironbar" = {
    #     source = ./config;
    #     recursive = true;
    #   };
    # };
    packages = [
      pkgs.ironbar
    ];
  };
}
