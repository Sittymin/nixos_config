{ ...
}:
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

  # # WARN: 出错！仅作归档查看
  # # ffmpeg -init_hw_device qsv=hw -filter_hw_device hw -v verbose -i input.mp4 -c:v av1_qsv output.mkv
  #
  # # Add hardware transcoding support to `ffmpeg_6` and derived packages (like jellyfin-ffmpeg)
  # # for Intel Alder Lake N100's Quick Sync Video (QSV) using Intel OneVPL.
  # # Remove once https://github.com/NixOS/nixpkgs/pull/264621 is merged.
  # nixpkgs.config.packageOverrides = prev: {
  #   jellyfin-ffmpeg = prev.jellyfin-ffmpeg.overrideAttrs (old: rec {
  #     configureFlags =
  #       # Remove deprecated Intel Media SDK support
  #       (builtins.filter (e: e != "--enable-libmfx") old.configureFlags)
  #       # Add Intel Video Processing Library (VPL) support
  #       ++ [ "--enable-libvpl" ];
  #     buildInputs = old.buildInputs ++ [
  #       # VPL dispatcher
  #       pkgs.libvpl
  #     ];
  #   });
  # };
  # # The VPL dispatcher searches LD_LIBRARY_PATH for runtime implemenations
  # environment.sessionVariables.LD_LIBRARY_PATH =
  #   lib.strings.makeLibraryPath (with pkgs; [
  #     # Intel oneVPL API runtime implementation for Intel Gen GPUs
  #     (pkgs.callPackage ./pkgs/onevpl-intel-gpu.nix { })
  #   ]);
}
