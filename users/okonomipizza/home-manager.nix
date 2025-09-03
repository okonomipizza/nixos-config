{ inputs, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:

let
  shellAliases = {
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gs = "git status";
  };

in
{
  imports = [
    ./hyprland
  ];
  home.stateVersion = "25.05";

  xdg.enable = true;

  #--------------------------------------------------
  # Packages
  #--------------------------------------------------
  home.packages =
    with pkgs;
    [
      bat
      eza
      fd
      gh
      jq
      tree
      gcc

      ghostty
    ]
    ++ [ inputs.zig.packages.${system}.master ];

  #--------------------------------------------------
  # dotfiles
  #--------------------------------------------------
  xdg.configFile = {
    "ghostty/config".text = builtins.readFile ./ghostty.linux;
  };

  #--------------------------------------------------
  # Programs
  #--------------------------------------------------
  programs.zsh = {
    enable = true;
    shellAliases = shellAliases;
  };

  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ./starship.toml;
  };

  programs.git = {
    enable = true;
    userName = "okonomipizza";
    userEmail = "140386510+okonomipizza@users.noreply.github.com";
    extraConfig = {
      color.ui = true;
      github.user = "okonomipizza";
      init.defaultBranch = "main";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraLuaConfig = lib.fileContents ./nvim.lua;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      
      blink-cmp
      telescope-nvim

      # UI
      telescope-nvim
      nvim-tree-lua
      kanagawa-nvim
      lualine-nvim

      plenary-nvim
      nui-nvim
      nvim-web-devicons
    ];

    extraPackages = with pkgs; [
      lua-language-server
      nixd
    ];
  };

  # Browser
  programs.google-chrome.enable = true;
  programs.firefox.enable = true;
}
