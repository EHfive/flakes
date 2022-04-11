{ config, pkgs, lib, ... }:
{
  age.secrets.mosdnsConfig.file = ./secrets/mosdns.yaml.age;
  age.secrets.tproxyRule.file = ./secrets/tproxy.nft.age;
  age.secrets.v2rayConfig.file = ./secrets/v2ray.jsonc.age;

  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      substituters = lib.mkBefore [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "nixos-r2s";

  time.timeZone = "Asia/Shanghai";

  documentation.man.enable = true;
  documentation.dev.enable = false;
  documentation.doc.enable = false;

  programs.vim.defaultEditor = true;

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

  system.autoUpgrade = {
    enable = false;
    flake = "github:EHfive/flakes";
    allowReboot = true;
    rebootWindow.lower = "01:00";
    rebootWindow.upper = "05:00";
  };
  nix.gc.automatic = true;
  nix.optimise.automatic = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3wDrWMAdPILZrRGggLHrvV3qsctMS/TrQkFdc4c81r"
  ];

  environment.systemPackages = with pkgs; [
    htop
    lm_sensors
  ];
}
