{
  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "rust-overlay/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    kidex-src.url = "github:Kirottu/kidex";
    kidex-src.flake = false;
  };

  outputs = inputs@{ nixpkgs, rust-overlay, kidex-src, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({withSystem, ...}: {
      systems = ["x86_64-linux"];

      perSystem = {
        self',
	inputs',
        config,
	pkgs,
	system,
	...
      }: let 
        inherit (inputs.nixpkgs) lib;
      in {
        packages = rec {
	  kidex = pkgs.callPackage ./. { inherit rust-overlay nixpkgs system kidex-src; };
          default = kidex;
	};
      };

      flake.nixosModules.default = { pkgs, ... }: {
        imports = [ ./hm-module.nix ];
        services.kidex.package = withSystem pkgs.stdenv.hostPlatform.system ({ config, ... }:
          config.packages.default
        );
      };

    });   
}
