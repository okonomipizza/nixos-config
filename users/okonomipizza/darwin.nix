{ inputs, pkgs, ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;  # 自動更新
      cleanup = "uninstall";  # 未管理パッケージの削除
      upgrade = true;  # パッケージのアップグレード
    };

    taps = [
      "homebrew/bundle"
    ];

    # GUI
    casks  = [
      "discord"
    ];
  };

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.okonomipizza = {
    home = "/Users/okonomipizza";
    shell = pkgs.fish;
  };

  # Required for some settings like homebrew to know what user to apply to.
  system.primaryUser = "okonomipizza";
}