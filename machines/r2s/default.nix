{ self, system ? "aarch64-linux", nixpkgs, agenix }:
nixpkgs.lib.nixosSystem rec {
  inherit system;
  modules = [
    ./hardware.nix
    ./networking.nix
    ./router.nix
    ./configuration.nix
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
