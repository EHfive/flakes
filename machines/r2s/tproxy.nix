{ config, pkgs, lib, ... }:
let
  nftBin = "${pkgs.nftables}/bin/nft";
  startScript = pkgs.writeScript "setup-tproxy-start" ''
    #!${nftBin} -f
    include "${config.age.secrets.tproxyRule.path}"
  '';
  stopScript = pkgs.writeShellScript "setup-tproxy-stop" ''
    ${nftBin} delete table ip my_tproxy || true
  '';
in
{
  systemd.services.setup-tproxy = {
    enable = true;
    bindsTo = [ "v2ray-next.service" ];
    after = [ "v2ray-next.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = startScript;
      ExecStop = stopScript;
      RemainAfterExit = true;
    };
    restartTriggers = [ config.age.secrets.tproxyRule.path ];
  };

  systemd.network.networks."11-lo" = {
    name = "lo";
    routes = [{
      routeConfig = {
        Destination = "0.0.0.0/0";
        Table = 100;
        Type = "local";
      };
    }];
    routingPolicyRules = [{
      routingPolicyRuleConfig = {
        FirewallMark = 9;
        Table = 100;
      };
    }];
  };
}
