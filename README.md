# 安装流程

插入U盘进入官方的 [NixOS ISO image](https://nixos.org/download/#nixos-iso) 当中
```bash
# 查看磁盘设备
lsblk
```
按需修改`disk-config.nix`当中的格式化目标

进入临时目录并 Clone 本仓库
```bash
cd /tmp
sudo git clone https://codeberg.org/Sittymin/nixos_config
```

创建磁盘加密密钥(文件内容直接写入密码，当前是交互式密码解锁)
```bash
sudo vi /tmp/secret.key
```

开始分区格式化
```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/nixos_config/disk-config.nix
```

格式化后将 nixos_config 文件夹移动到持久路径当中(当前是`/nix/persistent`)
```bash
sudo cp /tmp/nixos_config /nix/persistent/
```

移动当前位置到新的`nixos_config`位置，并开始部署
(注意构建的临时位置也设置到持久路径当中，不然会构建大型软件时爆内存)
```bash
export TMPDIR=/nix/persistent
sudo nixos-install --flake .#nixos
```

完成后`reboot`，拔出U盘就会进入到系统
