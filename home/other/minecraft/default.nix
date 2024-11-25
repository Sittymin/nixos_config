{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (prismlauncher.override {
      jdks = [
        temurin-bin-21
        temurin-bin-17
      ];
      # Wayland 原生运行 Minecraft
      # 设置 -> Minecraft -> 微调 -> 使用系统 GLFW
    })
    # 为了联机
    # NOTE: -d: 以守护程序运行zerotier
    # sudo zerotier-one -d
    # NOTE: 查看运行状态
    # sudo zerotier-cli status
    # NOTE: 加入网络
    # zerotier-cli join <Network ID>
    # 离开网络
    # zerotier-cli leave <Network ID>
    # 列出网络
    # zerotier-cli listnetworks
    # NOTE: 加入网络后到 https://my.zerotier.com/network 对成员授权
    # NOTE: 最后使用成员后面的 Managed IPs + Port 就可以连接那个成员的服务器了
    # zerotierone
  ];
}
