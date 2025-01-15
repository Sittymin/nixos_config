{
  pkgs,
  ...
}:
{
  # NOTE:设置网络连接
  networking = {
    hostName = "nixos"; # NOTE:主机名
    # 下面的 nameservers 是依靠 resolvconf 生成的
    resolvconf.enable = true;
    # NOTE: 可能是下面的 dnsmasq 控制
    # 用 dnsmasq 的转发使用 sing-box DNS
    # nameservers = [
    #   "127.0.0.1"
    #   "::1"
    # ];
    # 如果不使用路由器 DNS 不知道为啥翻墙变慢(可能是校园网)
    # 额外添加的 DNS
    # 学校 DNS
    # nameservers = [
    #   "223.5.5.5"
    #   "172.30.18.18"
    #   "172.30.8.51"
    # ];
    dhcpcd = {
      enable = true;
      # 让 DHCP 不要修改 DNS 服务器
      extraConfig = "nohook resolv.conf";
    };

    networkmanager = {
      enable = true; # NOTE:启用NetworkManager来管理网络连接
      # 让 NetworkManager 不要修改 resolv.conf中的 DNS 服务器
      # dns = "none";
      dns = "dnsmasq";
    };
    # 防火墙由上级路由器配置
    firewall = {
      enable = false;
    };
    # NTP
    timeServers = [
      # 国家授时中心
      "ntp.ntsc.ac.cn"
      # "time.apple.com"
    ];
  };
  # 不能使用 resolved （不然不可以安全DNS）
  services.resolved.enable = false;
  services.dnsmasq = {
    enable = true;
    settings = {
      # path: /etc/dnsmasq.d/dns-servers.conf
      # only bind to lo
      interface = "lo";
      bind-interfaces = true;
      # not use or poll /etc/resolv.conf
      no-resolv = true;
      no-poll = true;
      # cache
      # max live in cache
      max-cache-ttl = 3600;
      # min live in cache
      min-cache-ttl = 300;
      # cache size
      cache-size = 1000;
      # 启用顺序来先尝试 sing-box
      strict-order = true;
      server = [
        # sing-box server
        "127.0.0.1#5335"
        # 回退源
        "223.5.5.5"
      ];
    };
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
      enable = false;
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
