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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      niri,
    #  zig,
      jsonc_fmt,
      ...
    }@inputs:
    let
      mkSystem = import ./lib/mksystem.nix {
        inherit nixpkgs inputs;
      };
      
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      nixosConfigurations.x86_64 = mkSystem "x86_64" rec {
        system = "x86_64-linux";
        user = "okonomipizza";
      };
      nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" rec {
        system = "aarch64-linux";
        user = "okonomipizza";
      };

      packages = forAllSystems (system:
        let
            pkgs = nixpkgs.legacyPackages.${system};
        in
        {
            efmt = pkgs.callPackage ./packages/efmt {};
        }
      );
    };
}
