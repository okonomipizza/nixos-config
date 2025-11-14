{
  config,
  pkgs,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      # Add extensions you want here, e.g.:
      # "nix"
      # "toml"
    ];
  };

  # Manage Zed configuration files
  xdg.configFile."zed/settings.json".source = ./settings.json;
  xdg.configFile."zed/keymap.json".source = ./keymap.json;

  # If you have themes or other config files:
  # xdg.configFile."zed/themes".source = ./themes;
}
