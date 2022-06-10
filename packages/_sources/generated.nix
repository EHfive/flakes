# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  geoip-dat = {
    pname = "geoip-dat";
    version = "202206092212";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202206092212/geoip.dat";
      sha256 = "sha256-yrpIOc0Re/TpKWQuwHqImCJfKX/OSXNHUP9msYAKRdg=";
    };
  };
  geosite-dat = {
    pname = "geosite-dat";
    version = "202206092212";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202206092212/geosite.dat";
      sha256 = "sha256-ZQPClNUyeblx+9/XDVDKKkoHnh0s3yufakj2FkyYXkI=";
    };
  };
  mosdns = {
    pname = "mosdns";
    version = "v3.9.0";
    src = fetchFromGitHub ({
      owner = "IrineSistiana";
      repo = "mosdns";
      rev = "v3.9.0";
      fetchSubmodules = false;
      sha256 = "sha256-VavBpBDjesBMhrNQipxBSBeGy1mr2F2WAvxGr+83i+o=";
    });
  };
  v2ray = {
    pname = "v2ray";
    version = "v5.0.6";
    src = fetchFromGitHub ({
      owner = "v2fly";
      repo = "v2ray-core";
      rev = "v5.0.6";
      fetchSubmodules = false;
      sha256 = "sha256-eseNLX9V12ZhMUEXPVP9XhvZHlJlsOqhaNY5/HS3bKs=";
    });
  };
}
