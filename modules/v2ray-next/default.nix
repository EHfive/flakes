{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.v2ray-next;
  v2rayBin = "${pkgs.v2ray-next}/bin/v2ray";
  configFormat = pkgs.formats.json { };
  configFile =
    if cfg.configFile != null
    then cfg.configFile
    else
      pkgs.writeTextFile {
        name = "v2ray.json";
        text = builtins.toJSON cfg.config;
        checkPhase = ''
          ${v2rayBin} test -config $out
        '';
      };
in
{
  options.services.v2ray-next = {
    enable = mkEnableOption "V2Ray v5 service";
    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The absolute path to the configuration file.";
    };
    config = mkOption {
      type = configFormat.type;
      default = { };
      description = "The configuration attribute set.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = (cfg.configFile != null) -> (cfg.config == { });
      message = "Either but not both `configFile` and `config` should be specified for v2ray.";
    }];

    systemd.services.v2ray-next = {
      description = "V2Ray v5 Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        # TODO: use `-confdir` so both `cfg.config` and `cfg.configFile` can be included,
        #       and allows specifying multiple config files.
        ExecStart = "${v2rayBin} run -config ${configFile}";
      };
    };
  };
}
