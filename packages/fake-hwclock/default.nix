{ lib, writeShellScriptBin }:
writeShellScriptBin "fake-hwclock" (builtins.readFile ./fake-hwclock.sh) // {
  meta = {
    description = "Fake hardware clock";
    license = lib.licenses.gpl3;
  };
}
