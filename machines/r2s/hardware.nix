{ config, pkgs, lib, ... }: {
  hardware.deviceTree.name = "rockchip/rk3328-nanopi-r2s.dtb";
  # hardware.deviceTree.filter = "*rk3328-nanopi-r2s.dtb";
  # hardware.deviceTree.overlays = [{
  #   name = "sysled";
  #   dtsFile = ./sysled.dts;
  # }];

  # nanopi r2s's DTS has not been actively updated, so just use the prebuilt one to avoid rebuild
  hardware.deviceTree.package = pkgs.lib.mkForce (
    pkgs.runCommand "dtbs-nanopi-r2s" { } ''
      mkdir -p $out/rockchip
      cp ${./rk3328-nanopi-r2s.dtb} -v --no-preserve=mode $out/rockchip/rk3328-nanopi-r2s.dtb
    ''
  );

  hardware.firmware = [ pkgs.linux-firmware ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  boot = {
    loader = {
      timeout = 0;
      grub.enable = false;
      generic-extlinux-compatible = {
        enable = true;
        configurationLimit = 0;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "console=ttyS2,1500000"
      "earlycon=uart8250,mmio32,0xff130000"
      "mitigations=off"
    ];
    initrd = {
      includeDefaultModules = false;
      kernelModules = [ "ledtrig-netdev" ];
    };
    blacklistedKernelModules = [ "hantro_vpu" "drm" "lima" "videodev" ];
    kernelModules = [ "ledtrig-netdev" ];
  };

  boot.kernel.sysctl = {
    "vm.vfs_cache_pressure" = 10;
    "vm.dirty_ratio" = 50;
    "vm.swappiness" = 20;
  };

  services.fake-hwclock.enable = true;

  systemd.services."setup-net-leds" = {
    description = "Setup network LEDs";
    unitConfig = { DefaultDependencies = "no"; };
    serviceConfig = { Type = "simple"; };
    wantedBy = [ "sysinit.target" ];
    script = ''
      cd /sys/class/leds/nanopi-r2s:green:lan
      echo netdev > trigger
      echo 1 | tee link tx rx >/dev/null
      echo intern0 > device_name

      cd /sys/class/leds/nanopi-r2s:green:wan
      echo netdev > trigger
      echo 1 | tee link tx rx >/dev/null
      echo extern0 > device_name
    '';
  };
  systemd.services."setup-sys-led" = {
    description = "Setup booted LED";
    serviceConfig = { Type = "idle"; };
    wantedBy = [ "multi-user.target" ];
    script = ''
      echo default-on > /sys/class/leds/nanopi-r2s:red:sys/trigger
    '';
  };
}
