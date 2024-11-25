{
  ...
}:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };
  # NOTE:蓝牙配对的一个GUI
  services.blueman.enable = true;
}
