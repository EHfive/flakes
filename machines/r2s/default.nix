{ self, system ? "aarch64-linux", nixpkgs, agenix }:
nixpkgs.lib.nixosSystem rec {
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
      nix = {
        nixPath = [ "nixpkgs=${nixpkgs}" ];
        registry.eh5.flake = self;
      };
      nixpkgs.overlays = [
        self.overlays.default
      ];
    }
  ];
}
