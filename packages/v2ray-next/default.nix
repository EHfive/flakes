{ lib
, callPackage
, fetchFromGitHub
, symlinkJoin
, buildGoModule
, runCommand
, makeWrapper
, v2ray-geoip
, v2ray-domain-list-community
, assets ? [ v2ray-geoip v2ray-domain-list-community ]
}:
let
  assetsDrv = symlinkJoin {
    name = "v2ray-assets";
    paths = assets;
  };

  source = (callPackage ../_sources/generated.nix { }).v2ray;
  core = buildGoModule rec {
    inherit (source) pname version src;
    vendorSha256 = "TaDAXgAicXm6x1qeXQR7/t9bRjy++fI3/uKlXrejVz8=";

    doCheck = false;

    buildPhase = ''
      buildFlagsArray=(-v -p $NIX_BUILD_CORES -ldflags="-s -w")
      runHook preBuild
      go build "''${buildFlagsArray[@]}" -o v2ray ./main
      runHook postBuild
    '';

    installPhase = ''
      install -Dm755 v2ray -t $out/bin
    '';

    meta = {
      homepage = "https://www.v2fly.org/en_US/";
      description = "A platform for building proxies to bypass network restrictions";
      license = lib.licenses.mit;
    };
  };
in
runCommand core.name
{
  inherit (core) version meta;
  nativeBuildInputs = [ makeWrapper ];
} ''
  for file in ${core}/bin/*; do
    makeWrapper "$file" "$out/bin/$(basename "$file")" \
      --set-default V2RAY_LOCATION_ASSET ${assetsDrv}/share/v2ray
  done
''
