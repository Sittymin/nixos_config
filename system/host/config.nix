{ pkgs
, ...
}: {
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        # 还不知道与上面的有什么区别
        # 查看 https://github.com/MordragT/nixos/blob/master/hosts/desktop/config.nix#L20 是否改变
        intel-compute-runtime.drivers
        # Intel VAAPI 驱动程序
        intel-media-driver
        # 参考: https://trac.ffmpeg.org/wiki/Hardware/QuickSync
        # ffmpeg -hwaccel qsv -c:v h264_qsv -i input.mp4 -c:v h264_qsv -global_quality 25 output.mp4
        #        使用qsv硬件加速 使用h264_qsv解码        使用h264_qsv编码 指定ICQ质量
        # ICQ值（例如0到23）会产生高质量的视频，适合需要高保真输出的应用，如专业视频编辑或存档。中等范围的ICQ值（例如24到35）
        # 如果画面变化快速可以使用-look_ahead <几帧>来让qsv可以预测然后再编码
        vpl-gpu-rt
        # 可能 Vulkan 需要吧
        intel-ocl
      ];
    };
  };

  # 使用 git 版本的 mesa
  # chaotic.mesa-git = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     intel-compute-runtime
  #     # 还不知道与上面的有什么区别
  #     # 查看 https://github.com/MordragT/nixos/blob/master/hosts/desktop/config.nix#L20 是否改变
  #     # intel-compute-runtime.drivers
  #     # Intel VAAPI 驱动程序
  #     intel-media-driver
  #     # 参考: https://trac.ffmpeg.org/wiki/Hardware/QuickSync
  #     # ffmpeg -hwaccel qsv -c:v h264_qsv -i input.mp4 -c:v h264_qsv -global_quality 25 output.mp4
  #     #        使用qsv硬件加速 使用h264_qsv解码        使用h264_qsv编码 指定ICQ质量
  #     # ICQ值（例如0到23）会产生高质量的视频，适合需要高保真输出的应用，如专业视频编辑或存档。中等范围的ICQ值（例如24到35）
  #     # 如果画面变化快速可以使用-look_ahead <几帧>来让qsv可以预测然后再编码
  #     vpl-gpu-rt
  #   ];
  # };
}
