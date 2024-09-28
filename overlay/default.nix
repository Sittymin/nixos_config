{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
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
