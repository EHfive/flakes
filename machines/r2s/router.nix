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
      server=127.0.0.1#5333
      local=/lan/
      interface=intern0
      bind-interfaces
      expand-hosts
      domain=lan
      dhcp-range=192.168.1.3,192.168.1.255,255.255.255.0,24h
      cache-size=0
      no-negcache
    '';
  };

  services.v2ray-next = {
    enable = true;
    configFile = config.age.secrets.v2rayConfig.path;
  };

  # slient redis
  boot.kernel.sysctl."vm.overcommit_memory" = 1;
  services.redis.servers.mosdns = {
    enable = true;
    port = 0;
    unixSocket = "/run/redis-mosdns/redis.sock";
  };

  services.mosdns = {
    enable = true;
    configFile = config.age.secrets.mosdnsConfig.path;
  };

  systemd.services.mosdns = {
    wantedBy = [ "redis-mosdns.service" ];
    after = [ "redis-mosdns.service" ];
  };
}
