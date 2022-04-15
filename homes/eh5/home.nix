{ config, lib, pkgs, ... }: {
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      substituters = lib.mkForce [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
        "https://eh5.cachix.org"
      ];
      trusted-public-keys = [ "eh5.cachix.org-1:pNWZ2OMjQ8RYKTbMsiU/AjztyyC8SwvxKOf6teMScKQ=" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  programs.home-manager.enable = true;
  programs.man.enable = false;

  targets.genericLinux.enable = true;

  xdg.mime.enable = false;

  home.language.base = "zh_CN.UTF-8";

  home.packages = [
    pkgs.cachix
    pkgs.rnix-lsp
    pkgs.ssh-to-age
    pkgs.nixos-cn.netease-cloud-music
  ];
}
