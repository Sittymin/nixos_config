{
  pkgs,
  inputs,
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
        "127.0.0.53"
        # 回退源
        "223.5.5.5"
      ];
    };
  };
  # 直接软链接有风险
  # environment.etc = {
  #   "dae/config.dae" = {
  #     source = ./config.dae;
  #     mode = "0640";
  #   };
  # };
  # dae 代理
  services.dae = {
    enable = true;

    openFirewall = {
      enable = true;
      port = 12345;
    };

    # default options

    #   package = inputs.daeuniverse.packages.x86_64-linux.daed;
    #   disableTxChecksumIpGeneric = false;
    configFile = "/home/Sittymin/StaticDoNotUpload/ForGFW/dae/config.dae";

    # geo 文件位置
    assetsPath = toString (
      pkgs.runCommand "dae-assets" { } ''
        mkdir -p $out
        ln -s ${inputs.v2ray-geoip-dat} $out/geoip.dat
        ln -s ${inputs.v2ray-geosite-dat} $out/geosite.dat
      ''
    );
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
      enable = false;
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

  services.mosdns = {
    enable = true;
    config = {
      log.level = "info";

      plugins = [
        # Domain/IP set
        {
          tag = "ads";
          type = "domain_set";
          args.files = [ "${inputs.mosdns_rule}/ads.txt" ];
        }
        {
          tag = "proxy";
          type = "domain_set";
          args.files = [ "${inputs.mosdns_rule}/proxy.txt" ];
        }
        # Upstream
        {
          tag = "upstream_cloudflare";
          type = "forward";
          args.concurrent = 2;
          args.upstreams = [
            {
              addr = "https://1.1.1.1/dns-query";
              # 无法使用?
              # socks5 = "127.0.0.1:7874";
            }
            {
              addr = "https://1.0.0.1/dns-query";
              # 无法使用?
              # socks5 = "127.0.0.1:7874";
            }
          ];
        }
        {
          tag = "upstream_alidns";
          type = "forward";
          args.concurrent = 2;
          args.upstreams = [
            { addr = "https://223.5.5.5/dns-query"; }
            { addr = "https://223.6.6.6/dns-query"; }
          ];
        }
        # Main
        {
          tag = "main";
          type = "sequence";
          args = [
            # 对于国内域名, 转发到国内 DNS 以保证速度
            {
              matches = "qname $ads";
              exec = "reject 2";
            }
            {
              exec = "cache 1024"; # 然后。查找 cache。
            }
            {
              matches = "has_resp";
              exec = "accept";
            }
            {
              matches = "!qname $proxy";
              exec = "$upstream_alidns";
            }
            {
              # 返回不是内网 IP
              matches = [ "!resp_ip 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 fc00::/7" ];
              exec = "accept";
            }
            # 因为可能没有很好的境外 IPv6 连接能力
            {
              exec = "prefer_ipv4";
            }
            {
              exec = "$upstream_cloudflare";
            }
          ];
        }
        # Server
        {
          type = "udp_server";
          args = {
            entry = "main";
            listen = "127.0.0.53:53";
          };
        }
      ];
    };
  };

}
