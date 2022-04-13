let
  utils = import ../utils;
  allPackages = pkgs:
    let
      callPackage = fn: args:
        utils.ifTrueWithOr
          (utils.checkPlatform pkgs.system)
          (pkgs.callPackage fn args)
          null;
    in
    (import ./packages.nix) { inherit callPackage; };
in
rec {
  packages = pkgs: builtins.foldl'
    (sum: name:
      if builtins.hasAttr name pkgs && pkgs.${name} != null then
        sum // { ${name} = pkgs.${name}; }
      else sum
    )
    { }
    (builtins.attrNames (allPackages pkgs));
  overlay = final: prev: allPackages final;
}
