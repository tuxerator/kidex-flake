{ pkgs, system, kidex-src, lib, ... }:
  pkgs.rustPlatform.buildRustPackage {
    pname = "kidex";
    version = "0.1.1";
    src = kidex-src;
    cargoHash = "sha256-BkpiJZZ83RrSSmbxM/TBl8rx5wIxLwYDZvFWdTwlUSI=";
}
