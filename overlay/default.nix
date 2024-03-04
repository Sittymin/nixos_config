{ config
, pkgs
, lib
, ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      kitty = prev.kitty.overrideAttrs (oldAttrs: rec {
        version = "0.31.0";

        src = prev.fetchFromGitHub {
          owner = "kovidgoyal";
          repo = "kitty";
          rev = "refs/tags/v${version}";
          hash = "sha256-VWWuC4T0pyTgqPNm0gNL1j3FShU5b8S157C1dKLon1g=";
        };

        goModules = (prev.buildGoModule {
          pname = "kitty-go-modules";
          inherit src version;
          vendorHash = "sha256-OyZAWefSIiLQO0icxMIHWH3BKgNas8HIxLcse/qWKcU=";
        }).goModules;
      });
      monaspace = prev.monaspace.overrideAttrs (finalAttrs: previousAttrs: {
        installPhase = ''
          runHook preInstall
          pushd monaspace-v${previousAttrs.version}/fonts/
          install -Dm644 otf/MonaspaceNeon*.otf -t $out/share/fonts/opentype
          install -Dm644 variable/MonaspaceNeon*.ttf -t $out/share/fonts/truetype
          install -Dm644 webfonts/MonaspaceNeon*.woff -t $woff/share/fonts/woff
          popd

          runHook postInstall
        '';
      });
    })
  ];
}
