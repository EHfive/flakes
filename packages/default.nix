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
      fake-hwclock = callPackage ./fake-hwclock {};
      mosdns = callPackage ./mosdns { };
      ubootNanopiR2s = callPackage ./uboot-nanopi-r2s { };
      v2ray-next = callPackage ./v2ray-next { };
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
