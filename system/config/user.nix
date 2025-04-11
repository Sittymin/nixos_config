{
  pkgs,
  ...
}:
{
  # NOTE:设置用户账户
  users = {
    # NOTE:禁用多用户
    mutableUsers = false;
    users.Sittymin = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "audio"
        "kvm"
        "libvirtd"
        "docker"
        "input"
        # 摄像头的用户组
        "tape"
      ];
      # NOTE:家目录
      home = "/home/Sittymin";
      # NOTE:默认shell
      shell = pkgs.nushell;
      # NOTE:使用mkpasswd -m yescrypt生成的密码
      hashedPassword = "$y$j9T$b0txaUn/Di7FBas5KhsG7/$LLW6.boQATgduZBQCRgqeObBI/Whf2.7Smd3g5g2lf9";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5zdW/9XICvpMixsfbg5IvYyDjfRC1eAJ1Yc1jdOLnz mail@sittymin.top"
      ];
    };
  };
}
