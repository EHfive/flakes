{ config, pkgs, lib, ... }: {
  networking.nftables = {
    enable = true;
    rulesetFile = ./nftables.nft;
  };
  systemd.services.nftables = {
    wants = [ "systemd-udev-settle.service" ];
    after = [ "systemd-udev-settle.service" ];
  };

  services.resolved.enable = false;
  services.dnsmasq = {
    enable = true;
    extraConfig = ''
      no-resolv
      server=223.5.5.5
      local=/lan/
      interface=intern0
      bind-interfaces
      expand-hosts
      domain=lan
      dhcp-range=192.168.1.3,192.168.1.255,255.255.255.0,24h
      cache-size=150
      no-negcache
    '';
  };

  services.v2ray-next = {
    enable = true;
    configFile = config.age.secrets.v2rayConfig.path;
  };

  services.mosdns = {
    enable = true;
    configFile = config.age.secrets.mosdnsConfig.path;
  };
}
