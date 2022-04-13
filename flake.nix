{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
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
    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };
  };
  outputs = { self, nixpkgs, flake-utils, agenix, deploy-rs, nvfetcher, ... }:
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
          appPkgs = utils.attrsFilterNonNull {
            agenix = agenix.defaultPackage.${system};
            deploy = deploy-rs.defaultPackage.${system};
            nvfetcher = nvfetcher.defaultPackage.${system} or null;
          };
        in
        rec {
          packages = myPkgs.packages pkgs;
          checks = packages;
          apps = builtins.mapAttrs (name: value: mkApp { drv = value; }) appPkgs;
          devShells.default = pkgs.mkShell {
            buildInputs = (builtins.attrValues packages) ++ (builtins.attrValues appPkgs);
          };
        }
      )
    // {
      lib.utils = utils;

      overlays.default = myPkgs.overlay;

      nixosModules = import ./modules;

      nixosConfigurations = {
        nixos-r2s = import ./machines/r2s {
          system = systems.aarch64-linux;
          inherit self nixpkgs agenix;
        };
      };

      deploy.nodes.nixos-r2s = with deploy-rs.lib.aarch64-linux; {
        hostname = "r2s";
        sshUser = "root";
        fastConnection = true;
        profiles.system.path = activate.nixos self.nixosConfigurations.nixos-r2s;
      };
    };
}
