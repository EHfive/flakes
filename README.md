# EHfive's Nix flakes

## packages

| Name           | Description                  | Platforms     |
| -------------- | ---------------------------- | ------------- |
| fake-hwclock   | Fake hardware clock          | \*            |
| mosdns         | A DNS proxy                  | \*            |
| ubootNanopiR2s | U-Boot images for NanoPi R2S | aarch64-linux |
| v2ray-next     | V2Ray v5                     | \*            |

`nixpkgs` overlay `.#overlays.default`

## nixosModules

| Module       | Option                           | Type           | Description                 |
| ------------ | -------------------------------- | -------------- | --------------------------- |
| fake-hwclock | `services.fake-hwclock.enable`   | boolean        | Fake hardware clock service |
| mosdns       | `services.mosdns.enable`         | boolean        | mosdns service              |
|              | `services.mosdns.config`         | JSON value     |                             |
|              | `services.mosdns.configFile`     | string \| null |                             |
| v2ray-next   | `services.v2ray-next.enable`     | boolean        | V2ray v5 service            |
|              | `services.v2ray-next.config`     | YAML value     |                             |
|              | `services.v2ray-next.configFile` | string \| null |                             |

Some of the modules requires some packages declared above, hence requiring `.#overlays.default` to be applied.
