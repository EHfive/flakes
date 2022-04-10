let
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII3cCSsIkKU6Y1WYbxAktRIAzUyUhDv4YlKtSRMUoYpR";
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYL/EA17rMN4WhOySVTjSythUcl4v6NrJbnwKf28y+0";
  keys = [ system user ];
  files = [
    "mosdns.yaml.age"
    "v2ray.jsonc.age"
  ];
in
builtins.listToAttrs (
  builtins.map
    (name: { inherit name; value.publicKeys = keys; })
    files
)
