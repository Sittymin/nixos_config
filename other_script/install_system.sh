#!/bin/bash

# Is root user ?
if [ "$EUID" -ne 0 ]; then
  echo "Please use root user"
  exit 1
else
  echo "Start install"
  # 在这里执行需要root权限的命令
  curl https://raw.githubusercontent.com/Sittymin/nixos_config/main/other_script/disk-config.nix  -o /tmp/disk-config.nix

  # TODO: 可能会输入错误，比如不合法的磁盘名
  echo "Please input disk name (example: /dev/nvme0n1):"
  read new_disk_name

  # 检查用户输入是否为空
  if [[ -z "$new_disk_name" ]]; then
    echo "Input empty!"
    exit 1
  fi

  cd /tmp
  # 使用sed命令替换配置文件中的<disk-name>
  sed -i "s/<disk-name>/$new_disk_name/g" disk-config.nix

  echo "Edit disk-config succes: $new_disk_name"

  nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disk-config.nix

  nixos-generate-config --no-filesystems --root /mnt

  git clone https://github.com/Sittymin/nixos_config.git

  # -f 表示强制
  cp -f /tmp/disk-config.nix ./nixos_config/disk-config.nix
  mv -f /mnt/etc/nixos/hardware-configuration.nix ./nixos_config/hardware-configuration.nix
  # -a 表示保留时间戳
  cp -a ./nixos_config/* /mnt/etc/nixos/

  nixos-install

  # 可能默认不会创建, 导致无法登录用户
  mkdir /mnt/home/Sittymin

  echo "Done"
fi
