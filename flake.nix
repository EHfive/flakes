{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };
  };
  outputs = { self, nixpkgs, flake-utils, agenix, deploy-rs, ... }:
    let
      inherit (flake-utils.lib) eachDefaultSystem mkApp;
      systems = flake-utils.lib.system;
      utils = import ./utils;
      myPkgs = import ./packages;
    in
    eachDefaultSystem
      (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ self.overlays.default ];
          };
        in
        nixpkgs.lib.recursiveUpdate
          {
            packages = myPkgs.packages pkgs;
          }
          {
            apps = {
              agenix = mkApp { drv = agenix.defaultPackage.${system}; };
              deploy = deploy-rs.apps.${system}.deploy-rs;
            };
          }
      )
    // {
      lib.utils = utils;

      overlays.default = myPkgs.overlay;

      nixosConfigurations = {
        nixos-r2s = import ./machines/r2s {
          system = systems.aarch64-linux;
          inherit self nixpkgs agenix;
        };
      };

      deploy.nodes.nixos-r2s = with deploy-rs.lib.aarch64-linux; {
        hostname = "r2s";
        sshUser = "root";
        profiles.system.path = activate.nixos self.nixosConfigurations.nixos-r2s;
      };
    };
}
