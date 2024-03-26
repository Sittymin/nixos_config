{ config
, pkgs
, lib
, ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      # pythonPackagesExtensions =
      #   prev.pythonPackagesExtensions
      #   ++ [
      #     (
      #       python-final: python-prev: {
      #         catppuccin = python-prev.catppuccin.overridePythonAttrs (oldAttrs: rec {
      #           version = "1.3.2";
      #           src = prev.fetchFromGitHub {
      #             owner = "catppuccin";
      #             repo = "python";
      #             rev = "refs/tags/v${version}";
      #             hash = "sha256-spPZdQ+x3isyeBXZ/J2QE6zNhyHRfyRQGiHreuXzzik=";
      #           };
      #
      #           # can be removed next version
      #           disabledTestPaths = [
      #             "tests/test_flavour.py" # would download a json to check correctness of flavours
      #           ];
      #         });
      #       }
      #     )
      #   ];
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

  # Add hardware transcoding support to `ffmpeg_6` and derived packages (like jellyfin-ffmpeg)
  # for Intel Alder Lake N100's Quick Sync Video (QSV) using Intel OneVPL.
  # Remove once https://github.com/NixOS/nixpkgs/pull/264621 is merged.
  nixpkgs.config.packageOverrides = prev: {
    jellyfin-ffmpeg = prev.jellyfin-ffmpeg.overrideAttrs (old: rec {
      configureFlags =
        # Remove deprecated Intel Media SDK support
        (builtins.filter (e: e != "--enable-libmfx") old.configureFlags)
        # Add Intel Video Processing Library (VPL) support
        ++ [ "--enable-libvpl" ];
      buildInputs = old.buildInputs ++ [
        # VPL dispatcher
        pkgs.libvpl
      ];
    });
  };
  # The VPL dispatcher searches LD_LIBRARY_PATH for runtime implemenations
  environment.sessionVariables.LD_LIBRARY_PATH =
    lib.strings.makeLibraryPath (with pkgs; [
      # Intel oneVPL API runtime implementation for Intel Gen GPUs
      (pkgs.callPackage ./pkgs/onevpl-intel-gpu.nix { })
    ]);
}
