{ ...
}: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # 为了让pipewire正常运行的一些东西
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
}
