{ pkgs
, inputs
, ...
}: {
  environment.systemPackages = [
    inputs.swww.packages.${pkgs.system}.swww
  ];
}
