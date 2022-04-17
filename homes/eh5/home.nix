{ config, lib, pkgs, ... }:
let
  clang14-tools =
    let
      inherit (pkgs.llvmPackages_14) clang-unwrapped clang;
    in
    pkgs.clang-tools.overrideAttrs (_: {
      version = lib.getVersion clang-unwrapped;
      inherit clang;
    });
in
{
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      substituters = lib.mkForce [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
        "https://eh5.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "eh5.cachix.org-1:pNWZ2OMjQ8RYKTbMsiU/AjztyyC8SwvxKOf6teMScKQ="
      ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  programs.home-manager.enable = true;
  programs.man.enable = false;

  targets.genericLinux.enable = true;

  xdg.mime.enable = false;

  home.language.base = "zh_CN.UTF-8";

  home.packages = with pkgs; [
    cachix
    clang14-tools
    rnix-lsp
    ssh-to-age
    netease-cloud-music
    nixgl.nixGLIntel
  ];
}
