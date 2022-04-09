{ lib, runCommand, buildGoModule, fetchFromGitHub, makeBinaryWrapper, symlinkJoin, v2ray-geoip, v2ray-domain-list-community }:
let
  assetsDrv = symlinkJoin {
    name = "mosdns-assets";
    paths = [
      "${v2ray-geoip}/share/v2ray"
      "${v2ray-domain-list-community}/share/v2ray"
    ];
  };
  version = "3.7.2";
  mosdns = buildGoModule rec {
    pname = "mosdns";
    inherit version;
    src = fetchFromGitHub {
      owner = "IrineSistiana";
      repo = "mosdns";
      rev = "v${version}";
      sha256 = "0p45mavjarfvsxjm3mdlv9s9inhpwp0czjhks6iypjvl47cs6ykd";
    };
    vendorSha256 = "2AF3ONhD6xH6m6QFmxRBUNsk6Nd8yrXVyCFjhDJDFx4=";
    doCheck = false;

    meta = with lib; {
      description = "A DNS proxy server";
      homepage = "https://github.com/IrineSistiana/mosdns";
      license = licenses.gpl3;
    };
  };
in
runCommand "mosdns-${version}"
{
  inherit (mosdns) meta;
  nativeBuildInputs = [ makeBinaryWrapper ];
} ''
  makeWrapper ${mosdns}/bin/mosdns "$out/bin/mosdns" --chdir ${assetsDrv}
''
