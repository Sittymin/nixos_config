{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    (prismlauncher.override
      {
        jdks = [ temurin-bin temurin-bin-17 ];
        withWaylandGLFW = true;
      }
    )
  ];
}
