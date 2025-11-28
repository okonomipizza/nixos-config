{
  description = "NixOS systems and tools by okonomipizza";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # snapd
    nix-snapd.url = "github:nix-community/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    # wayland compositor
    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #zig = {
    #  url = "github:mitchellh/zig-overlay";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    jsonc_fmt = {
      url = "github:okonomipizza/jsonc_fmt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    iroha = {
      url = "github:okonomipizza/iroha/v0.2.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xpack-arm-gcc = {
      url = "path:./packages/xpack-arm-gcc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    ghostty,
    niri,
    #  zig,
    jsonc_fmt,
    iroha,
    xpack-arm-gcc,
    ...
  } @ inputs: let
    mkSystem = import ./lib/mksystem.nix {
      inherit nixpkgs inputs;
    };

    supportedSystems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    nixosConfigurations.x86_64 = mkSystem "x86_64" rec {
      system = "x86_64-linux";
      user = "okonomipizza";
    };
    nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" rec {
      system = "aarch64-linux";
      user = "okonomipizza";
    };

    darwinConfigurations.macbook = mkSystem "macbook" {
      system = "aarch64-darwin";
      user = "okonomipizza";
      darwin = true;
    };

    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        efmt = pkgs.callPackage ./packages/efmt {};
      }
    );
  };
}
