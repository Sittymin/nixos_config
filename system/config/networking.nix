{
  pkgs,
  inputs,
  ...
}:
{
  # NOTE:设置网络连接
  environment.etc = {
    # networkmanager 内置的 dnsmasq 的配置
    "NetworkManager/dnsmasq.d/mosdns".text = ''
      # 指定 mosdns 作为首选 DNS 服务器
      server=127.0.0.53

      # 我的软路由
      server=192.168.47.1

      # 指定 223.5.5.5 作为备用 DNS 服务器
      server=223.5.5.5

      # 告诉 dnsmasq 不要从 /etc/resolv.conf 读取上游服务器
      # (因为 NetworkManager 会将 /etc/resolv.conf 指向这个 dnsmasq 实例本身)
      no-resolv

      # 禁用 dnsmasq 的缓存功能
      # 由 mosdns 负责
      cache-size=0

      # 严格按照配置文件中 server 的顺序进行查询
      strict-order

      # 记录转发目标服务器的日志
      log-queries
    '';
  };
  networking = {
    # NOTE:主机名
    hostName = "nixos";
    # resolv.conf 改用 networkmanager 控制
    resolvconf.enable = false;

    # dhcp 改用 networkmanager 控制
    dhcpcd.enable = false;

    networkmanager = {
      enable = true;
      # 这里使用的是它内置的dnsmasq
      dns = "dnsmasq";
      # 使用内置的 dhcp 客户端
      dhcp = "internal";
      settings = {
        main = {
          # 使用软链接配置resolv.conf
          # 似乎只是变成 networkmanager 来生成 resolv.conf
          "rc-manager" = "symlink";
        };
      };
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
  # 不使用 systemd-resolved 来管理 DNS
  # DNS 改用 networkmanager 控制
  services.resolved.enable = false;
  # 使用 networkmanager 自带的
  services.dnsmasq.enable = false;

  # 直接软链接有风险
  # environment.etc = {
  #   "dae/config.dae" = {
  #     source = ./config.dae;
  #     mode = "0640";
  #   };
  # };
  # dae 代理
  services.dae = {
    # NOTE: 公司里先用路由器的代理了
    enable = false;

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
      # 用于发送命令
      api.http = "127.0.0.53:80";

      plugins = [
        # Domain/IP set
        # WARN: 这里有问题！会导致海外域名被屏蔽
        {
          tag = "ads";
          type = "domain_set";
          args.files = [ "${inputs.adsList}" ];
        }
        {
          tag = "proxy";
          type = "domain_set";
          args.files = [ "${inputs.proxyList}" ];
        }
        {
          tag = "direct";
          type = "domain_set";
          args.files = [ "${inputs.directList}" ];
        }
        # Upstream
        {
          tag = "upstream_cloudflare";
          type = "forward";
          args.concurrent = 2;
          args.upstreams = [
            {
              # NOTE: 本来就会与 VPS 建立 TLS 连接
              # NOTE: DNS 再建立一个握手实在是太慢了
              # addr = "https://one.one.one.one/dns-query";
              addr = "1.1.1.1";
              # 无法使用?
              # socks5 = "127.0.0.1:7874";
              # dial_addr = "1.1.1.1";
              # 解析出的 IP 版本
              # bootstrap_version = 4;
              # 连接复用保持时间 单位秒
              # idle_timeout = 300;
              # enable_pipeline = true;
              # enable_http3 = true;
            }
            {
              # addr = "https://one.one.one.one/dns-query";
              addr = "1.0.0.1";
              # 无法使用?
              # socks5 = "127.0.0.1:7874";
              # dial_addr = "1.0.0.1";
              # 解析出的 IP 版本
              # bootstrap_version = 4;
              # 连接复用保持时间 单位秒
              # idle_timeout = 300;
              # enable_pipeline = true;
              # enable_http3 = true;
            }
          ];
        }
        {
          tag = "upstream_alidns";
          type = "forward";
          args.concurrent = 2;
          args.upstreams = [
            {
              addr = "https://223.5.5.5/dns-query";
              # dial_addr = "223.5.5.5";
              enable_http3 = true;
            }
            {
              addr = "https://223.6.6.6/dns-query";
              # dial_addr = "223.6.6.6";
              enable_http3 = true;
            }
          ];
        }
        {
          tag = "cache";
          type = "cache";
          args = {
            size = 1024; # 内置内存缓存大小。单位= 条。默认= 1024。每个 cache 插件的内存缓存是独立的。

            # (实验性) lazy cache 设定。lazy_cache_ttl > 0 会启用 lazy cache。
            # 所有应答都会在缓存中存留 lazy_cache_ttl 秒，但自身的 TTL 仍然有效。如果命中过期的应答，
            # 则缓存会立即返回 TTL 为 5 的应答，然后自动在后台发送请求更新数据。
            # 相比强行增加应答自身的 TTL 的方法，lazy cache 能提高命中率，同时还能保持一定的数据新鲜度。
            lazy_cache_ttl = 86400; # lazy cache 生存时间。单位= 秒。默认= 0 (禁用 lazy cache)。
            # 建议值 86400（1天）~ 259200（3天）

          };
        }
        # Main
        {
          tag = "main";
          type = "sequence";
          args = [
            # WARN: 修改之后部署之后需要利用systemctl 重启
            {
              matches = "qname $ads";
              exec = "reject 2";
            }
            {
              matches = [
                "!qname ddns.ideal2077.com ddnsv6.ideal2077.com ddns.sittymin.top ddnsv6.sittymin.top"
              ];
              exec = "$cache"; # 然后。查找 cache。
            }
            {
              matches = "has_resp";
              exec = "query_summary 命中缓存";
            }
            {
              matches = "has_resp";
              exec = "accept";
            }
            {
              # 对于国内域名, 转发到国内 DNS 以保证速度
              # WARN: 数组中只可以有一条，不然会不匹配
              matches = [
                "qname $direct jp.sittymin.top bwg.wujiacheng.top new.tuhaobo.top store.steampowered.com"
              ];
              exec = "$upstream_alidns";
            }
            {
              matches = [
                "qname ddns.ideal2077.com ddnsv6.ideal2077.com ddns.sittymin.top ddnsv6.sittymin.top"
              ];
              exec = "ttl 1"; # ddns 域名 TTL 缩短
            }
            {
              matches = [ "has_resp" ];
              exec = "query_summary 国内解析";
            }
            {
              matches = [ "has_resp" ];
              exec = "accept";
            }
            {
              exec = "query_summary 删除 IPv6 回应";
            }
            {
              # 因为可能没有很好的境外 IPv6 连接能力
              exec = "prefer_ipv4";
            }
            {
              matches = [
                "qname ddns.ideal2077.com ddnsv6.ideal2077.com ddns.sittymin.top ddnsv6.sittymin.top"
              ];
              exec = "ttl 1"; # ddns 域名 TTL 缩短
            }
            {
              matches = [
                "qname $proxy blog.sittymin.top"
              ];
              exec = "$upstream_cloudflare";
            }
            {
              matches = [ "has_resp" ];
              exec = "query_summary 国外解析";
            }
            {
              matches = [ "has_resp" ];
              exec = "accept";
            }
            {
              exec = "$upstream_alidns";
            }
            {
              matches = [
                "!resp_ip 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 0.0.0.0 127.0.0.0/8 169.254.0.0/16 100.64.0.0/10 192.0.0.0/24 192.0.2.0/24 198.18.0.0/15 198.51.100.0/24 203.0.113.0/24 224.0.0.0/4 233.252.0.0/24 240.0.0.0/4"
              ];
              exec = "query_summary 国外域名国内解析";
            }
            {
              matches = [
                "resp_ip 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 0.0.0.0 127.0.0.0/8 169.254.0.0/16 100.64.0.0/10 192.0.0.0/24 192.0.2.0/24 198.18.0.0/15 198.51.100.0/24 203.0.113.0/24 224.0.0.0/4 233.252.0.0/24 240.0.0.0/4"
              ];
              exec = "query_summary 国外域名国外解析";
            }
            {
              matches = [
                "resp_ip 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 0.0.0.0 127.0.0.0/8 169.254.0.0/16 100.64.0.0/10 192.0.0.0/24 192.0.2.0/24 198.18.0.0/15 198.51.100.0/24 203.0.113.0/24 224.0.0.0/4 233.252.0.0/24 240.0.0.0/4"
              ];
              exec = "$upstream_cloudflare";
            }
            {
              matches = [ "has_resp" ];
              exec = "accept";
            }
            {
              exec = "$upstream_alidns";
            }
            {
              matches = [ "has_resp" ];
              exec = "query_summary 国外解析失败回退到国内解析";
            }
            {
              matches = [ "has_resp" ];
              exec = "accept";
            }
            {
              exec = "query_summary 回退到国内解析也失败了";
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
        {
          type = "tcp_server";
          args = {
            entry = "main";
            listen = "127.0.0.53:53";
          };
        }
      ];
    };
  };

}
