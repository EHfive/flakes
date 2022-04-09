let
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII3cCSsIkKU6Y1WYbxAktRIAzUyUhDv4YlKtSRMUoYpR";
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYL/EA17rMN4WhOySVTjSythUcl4v6NrJbnwKf28y+0";
  keys = [ system user ];
in
{
  "v2ray.jsonc.age".publicKeys = keys;
}
