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

> 注意可能在此时无法直接安装安全启动  
> 可以删除`flake.nix`当中的安全启动部分，再安装完成后进入系统后再按照 [lanzaboote 教程](https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md)启用

移动当前位置到新的`nixos_config`位置，并开始部署
(注意构建的临时位置也设置到持久路径当中，不然会构建大型软件时爆内存)
```bash
export TMPDIR=/nix/persistent
sudo nixos-install --flake .#nixos
```

完成后`reboot`，拔出U盘就会进入到系统

### TPM 来解锁 LUKS

#### 前提条件

需要完成安全启动并且`bootctl status`显示支持 TPM2

#### 操作步骤

```bash
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 --wipe-slot=tpm2 --tpm2-with-pin=true /dev/disk/by-partuuid/<LUKS 加密磁盘的 PARTUUID>
```

然后输入原先 LUKS 的解锁密码和打算给 TPM 设置的密码就行了

#### 其他
如果需要修改 LUKS 原先的交互式密码
```bash
# 查看原先交互式密码的卡槽（一般来说是0，然后 TPM 密码卡槽是1）
# 输出当中 systemd-tpm2 字段会告诉你 TPM 的密码是哪一个卡槽
sudo cryptsetup luksDump /dev/disk/by-partuuid/<LUKS 加密磁盘的 PARTUUID>

# 修改密码
sudo cryptsetup luksChangeKey /dev/disk/by-partuuid/<LUKS 加密磁盘的 PARTUUID> --key-slot 0
# 测试密码
sudo cryptsetup open --test-passphrase --key-slot 0 /dev/disk/by-partuuid/<LUKS 加密磁盘的 PARTUUID>
```
