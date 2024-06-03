{ ...
}: {
  # NOTE:设置网络连接
  networking = {
    hostName = "nixos"; # NOTE:主机名
    networkmanager.enable = true; # NOTE:启用NetworkManager来管理网络连接
  };
}
