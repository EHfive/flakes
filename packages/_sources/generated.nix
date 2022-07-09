# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  geoip-dat = {
    pname = "geoip-dat";
    version = "202207082210";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202207082210/geoip.dat";
      sha256 = "sha256-omo2d7XktjIjaFdhcS+ifUMnAlyhnDQu0OzVmrtQndw=";
    };
  };
  geosite-dat = {
    pname = "geosite-dat";
    version = "202207082210";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202207082210/geosite.dat";
      sha256 = "sha256-E6urIlFB3TArdecy9s4WKAwas7mB71ruNHGqqMM1c8w=";
    };
  };
  mosdns = {
    pname = "mosdns";
    version = "v4.1.5";
    src = fetchFromGitHub ({
      owner = "IrineSistiana";
      repo = "mosdns";
      rev = "v4.1.5";
      fetchSubmodules = false;
      sha256 = "sha256-I0/omV4N/JLKxF596G9nHvnptxLcDDbd6dRnQT5OxxI=";
    });
  };
  v2ray = {
    pname = "v2ray";
    version = "v5.0.7";
    src = fetchFromGitHub ({
      owner = "v2fly";
      repo = "v2ray-core";
      rev = "v5.0.7";
      fetchSubmodules = false;
      sha256 = "sha256-jFrjtAPym3LJcsudluJNOihQJtuVcnIvJris+kmBDgo=";
    });
  };
}
