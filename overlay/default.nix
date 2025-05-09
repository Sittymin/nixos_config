{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      monaspace = prev.monaspace.overrideAttrs (
        finalAttrs: previousAttrs: {
          installPhase = ''
            runHook preInstall
            pushd monaspace-v${previousAttrs.version}/fonts/
            install -Dm644 otf/MonaspaceNeon*.otf -t $out/share/fonts/opentype
            install -Dm644 variable/MonaspaceNeon*.ttf -t $out/share/fonts/truetype
            install -Dm644 webfonts/MonaspaceNeon*.woff -t $woff/share/fonts/woff
            popd

            runHook postInstall
          '';
        }
      );
      xdg-desktop-portal-termfilechooser = prev.xdg-desktop-portal-termfilechooser.overrideAttrs (
        finalAttrs: previousAttrs: {
          version = "1.1.0";

          src = previousAttrs.src.override {
            tag = "v${finalAttrs.version}";
            hash = "sha256-o2FBPSJrcyAz6bJKQukj6Y5ikGpFuH1Un1qwX4w73os=";
          };
        }
      );

      # google-cursor = prev.google-cursor.overrideAttrs (
      #   finalAttrs: previousAttrs: {
      #     preInstall = ''
      #       # Patch the index.theme files
      #       for dir in GoogleDot-*; do
      #         sed -i 's/Inherits="hicolor"/Inherits="Papirus-Dark"/' $dir/index.theme
      #       done
      #     '';
      #   }
      # );

      papirus-icon-theme = prev.papirus-icon-theme.overrideAttrs (
        finalAttrs: previousAttrs: {
          preInstall = ''
            # 修改 Papirus 系列图标主题中对 hicolor 的引用，并添加 Adwaita 作为回退源
            for dir in Papirus*; do
              sed -i 's|hicolor|hicolor-backup|g' "$dir/index.theme"
              # sed -i 's|hicolor-backup|Adwaita,hicolor-backup|g' "$dir/index.theme"
            done
          '';
        }
      );
    })
  ];
}
