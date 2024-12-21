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

      ironbar = prev.ironbar.overrideAttrs (
        finalAttrs: previousAttrs: {
          buildInputs =
            let
              lib = prev.lib;
              buildInputsWithoutIcons = lib.filter (
                x: x != prev.adwaita-icon-theme && x != prev.hicolor-icon-theme
              ) previousAttrs.buildInputs;
            in
            buildInputsWithoutIcons ++ [ prev.papirus-icon-theme ];

          gappsWrapperArgs =
            previousAttrs.gappsWrapperArgs
            + ''
              --set GTK_ICON_THEME "Papirus-Dark"
            '';
        }
      );
      google-cursor = prev.google-cursor.overrideAttrs (
        finalAttrs: previousAttrs: {
          preInstall = ''
            # Patch the index.theme files
            for dir in GoogleDot-*; do
              sed -i 's/Inherits="hicolor"/Inherits="Papirus-Dark"/' $dir/index.theme
            done
          '';
        }
      );

      papirus-icon-theme = prev.papirus-icon-theme.overrideAttrs (
        finalAttrs: previousAttrs: {
          preInstall = ''
            # 修改 Papirus 系列图标主题中对 hicolor 的引用
            for dir in Papirus*; do
              sed -i 's|hicolor|hicolor-backup|g' "$dir/index.theme"
            done
          '';
        }
      );
    })
  ];
}
