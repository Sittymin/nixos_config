{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    (prismlauncher.override
      { jdks = [ jdk17 ]; })
  ];
}
