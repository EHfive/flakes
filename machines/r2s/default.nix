{ self, system ? "aarch64-linux", nixpkgs, agenix }:
let
  inherit (nixpkgs) lib;
in
lib.nixosSystem rec {
  inherit system;
  modules = [
    ./configuration.nix
    ./tproxy.nix
    ./router.nix
    ./networking.nix
    ./hardware.nix
    self.nixosModules.fake-hwclock
    self.nixosModules.mosdns
    self.nixosModules.v2ray-next
    agenix.nixosModule
    {
      _module.args = { inherit nixpkgs; };
      nix = {
        nixPath = [ "nixpkgs=${nixpkgs}" ];
        registry.eh5.flake = self;
      };
      nixpkgs.overlays = [
        self.overlays.default
        self.overlays.v2ray-rules-dat
      ];
    }
  ];
}
