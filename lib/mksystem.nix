{
  nixpkgs,
  inputs,
}: name: {
  system,
  user,
}: let
  machineConfig = ../machines/${name}.nix;
  userOSConfig = ../users/${user}/nixos.nix;
  userHMConfig = ../users/${user}/home-manager.nix;

  systemFunc = nixpkgs.lib.nixosSystem;
  home-manager = inputs.home-manager.nixosModules;
in
  systemFunc rec {
    inherit system;

    modules = [
      # Allow unfree packages.
      {nixpkgs.config.allowUnfree = true;}

      inputs.nix-snapd.nixosModules.default

      machineConfig
      userOSConfig
      home-manager.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.${user} = import userHMConfig {
          currentSystemName = name;
          inputs = inputs;
        };
      }

      # We expose some extra arguments so that our modules can parameterize
      # better based on these values.
      {
        config._module.args = {
          currentSystem = system;
          currentSystemName = name;
          currentSystemUser = user;
          inputs = inputs;
        };
      }
    ];
  }
