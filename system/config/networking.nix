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
    # 如果不使用路由器 DNS 不知道为啥翻墙变慢(可能是校园网)
    # 额外添加的 DNS
    # 学校 DNS
    nameservers = [ "223.5.5.5" "172.30.18.18" "172.30.8.51" ];
    # 使用 resolvconf 管理 DNS
    resolvconf.enable = true;
    # 让 DHCP 不要修改 DNS 服务器
    dhcpcd.extraConfig = "nohook resolv.conf";

    networkmanager = {
      enable = true; # NOTE:启用NetworkManager来管理网络连接
      # 让 NetworkManager 不要修改 resolv.conf中的 DNS 服务器
      # dns = "none";
      # 不使用路由器的 DNS
      dns = "none";
    };
    # 防火墙由上级路由器配置
    firewall.enable = false;
    # NTP
    timeServers = [
      # 国家授时中心
      "ntp.ntsc.ac.cn"
      # "time.apple.com"
    ];
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
    # 自动登录、断网与连接
    school = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple"; # 确保服务启动后立即返回
        ExecStart = "/home/Sittymin/StaticDoNotUpload/SchoolLogin/school_network_control.sh";
        User = "root";
        Restart = "on-failure";
        Environment = "PATH=/run/current-system/sw/bin:/run/wrappers/bin:${pkgs.bun}/bin";
      };
      description = "School Network Control Service";
    };
    # sing-box 代理服务
    sing-box = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "school.service" ];
      serviceConfig = {
        WorkingDirectory = "/home/Sittymin";
        ExecStart = "${pkgs.sing-box}/bin/sing-box run -c /home/Sittymin/StaticDoNotUpload/ForGFW/singbox-config-tun.json5";
        User = "root";
        Restart = "on-failure";
        RestartSec = 10;
      };
      description = "Sing-box Service";
    };
  };

}
