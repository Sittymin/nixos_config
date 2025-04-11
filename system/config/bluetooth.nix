{
  pkgs,
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
  environment.systemPackages = [ pkgs.bluez ];
  # NOTE:蓝牙配对的一个GUI
  services.blueman.enable = true;
}
