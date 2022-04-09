let
  utils = import ../utils;
  allPackages = pkgs:
    let
      inherit (pkgs) system;
      callPackage = fn: args:
        let
          pkg = pkgs.callPackage fn args;
        in
        if utils.checkPlatform system pkg
        then pkg
        else null
      ;
    in
    {
      ubootNanopiR2s = callPackage ./uboot-nanopi-r2s { };
      mosdns = callPackage ./mosdns { };
    };
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
