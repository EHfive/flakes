{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "shadow-tls";
  version = "0.2.23";

  src = fetchFromGitHub {
    owner = "ihciah";
    repo = "shadow-tls";
    rev = "v${version}";
    sha256 = "sha256-XMoNCSSj76aGJzGatOudwWO21qimlgeRMGNUmzxzM6I=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "monoio-0.1.3" = "sha256-UEm+Zj86k7CTQO7gjmqeM2ajyp9UwBQ+t7UGi97oJuw=";
    };
  };

  doCheck = false;

  meta = with lib; {
    description = "A proxy to expose real tls handshake to the firewall.";
    homepage = "https://github.com/ihciah/shadow-tls";
    license = licenses.mit;
  };
}
