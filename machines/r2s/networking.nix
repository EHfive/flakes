{ config, pkgs, lib, ... }:
{
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.conf.default.forwarding" = true;
  };

  networking.useNetworkd = false;
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  networking.firewall.enable = false;

  systemd.network.enable = true;

  systemd.network.links."10-intern0" = {
    matchConfig.Path = "platform-ff540000.ethernet";
    linkConfig = {
      Name = "intern0";
      MACAddress = "fe:1b:f3:16:82:a6";
    };
  };

  systemd.network.links."10-extern0" = {
    matchConfig.Path = "platform-xhci-hcd.0.auto-usb-0:1:1.0";
    linkConfig = {
      Name = "extern0";
      MACAddress = "ea:ce:b4:a1:ce:94";
    };
  };

  systemd.network.networks."11-intern0" = {
    matchConfig.Name = "intern0";
    networkConfig = {
      Address = "192.168.1.1/24";
      ConfigureWithoutCarrier = true;
    };
    linkConfig.ActivationPolicy = "always-up";
  };

  systemd.network.networks."11-extern0" = {
    matchConfig.Name = "extern0";
    networkConfig = {
      Address = "192.168.4.16/24";
      DHCP = "ipv4";
      ConfigureWithoutCarrier = true;
    };
    dhcpV4Config = {
      SendHostname = true;
    };
    linkConfig.ActivationPolicy = "always-up";
  };
}
