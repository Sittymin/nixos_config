{ pkgs
, ...
}: {
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        # ffmpeg硬件编解码仍然需要上面的
        # 上面的应该被onevpl代替
        # ffmpeg -init_hw_device qsv=hw -filter_hw_device hw -v verbose -i input.mp4 -c:v av1_qsv output.mkv
        onevpl-intel-gpu
        # https://github.com/MordragT/nixos/blob/master/hosts/desktop/config.nix#L21
        intel-vaapi-driver
      ];
    };
  };
}
