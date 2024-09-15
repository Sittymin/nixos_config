{ pkgs
, ...
}:
# let
# GitHub520HostFile = builtins.fetchurl {
#   url = "https://raw.hellogithub.com/hosts";
#   sha256 = "1m3pdag28ng80why2gbxv12rxa6li3lmszxk83j326jvszlf2i1b";
# };
# GitHub520HostContent = builtins.readFile GitHub520HostFile;
# in
{
  # Github Host 文件
  # networking.extraHosts = GitHub520HostContent;

  # NOTE:设置网络连接
  networking = {
    hostName = "nixos"; # NOTE:主机名
    networkmanager.enable = true; # NOTE:启用NetworkManager来管理网络连接
    # 防火墙由上级路由器配置
    firewall.enable = false;
  };
  ### 目前 dae 还未支持 Reality
  # 直接软链接有风险
  # environment.etc = {
  #   "dae/config.dae" = {
  #     source = ./config.dae;
  #     mode = "0640";
  #   };
  # };
  # dae 代理
  services.dae = {
    enable = false;

    openFirewall = {
      enable = true;
      port = 12345;
    };

    # default options

    #   package = inputs.daeuniverse.packages.x86_64-linux.daed;
    #   disableTxChecksumIpGeneric = false;
    configFile = "/etc/dae/config.dae";

    # geo 文件位置
    assetsPath = "/etc/dae";
  };


  # 自定义的服务
  systemd.services = {
    # sing-box 服务
    sing-box = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.sing-box}/bin/sing-box run -c /home/Sittymin/sever_and_client_config/singbox-config-tun.json";
        User = "root";
        Restart = "on-failure";
        RestartSec = 10;
      };
      description = "Sing-box Service";
    };
    # 自动断网与连接
    school = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "/etc/nixos/other_script/school_network_control.sh";
        User = "root";
        Restart = "on-failure";
        Environment = "PATH=/run/current-system/sw/bin:/run/wrappers/bin";
      };
      description = "School Network Control Service";
    };
  };

}
