{ callPackage }: {
  fake-hwclock = callPackage ./fake-hwclock { };
  mosdns = callPackage ./mosdns { };
  ubootNanopiR2s = callPackage ./uboot-nanopi-r2s { };
  v2ray-next = callPackage ./v2ray-next { };
  v2ray-rules-dat-geoip = callPackage ./v2ray-geoip { };
  v2ray-rules-dat-geosite = callPackage ./v2ray-geosite { };
}
