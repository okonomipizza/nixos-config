{
  currentSystemName,
  inputs,
  ...
}: {
  config,
  lib,
  pkgs,
  ...
}: let
  shellAliases = {
    pn = "pnpm";
    ls = "ls -F";
    rm = "rm -i";
    cp = "cp -i";
    mv = "mv -i";
    ga = "git add";
    gc = "git commit";
    gco = "git checkout";
    gdiff = "git diff";
    gp = "git push";
    gs = "git status";
    zed = "zeditor";
    sd = "sudo systemctl poweroff";
    v = "nvim";
  };
in {
  imports = [
    ./niri
    ./waybar
    ./zed
  ];
  home.stateVersion = "25.05";

  xdg.enable = true;

  #--------------------------------------------------
  # Packages
  #--------------------------------------------------
  home.packages = with pkgs;
    [
      # CLI
      bat
      eza
      fd
      gh
      jq
      tree
      gcc
      libnotify

      nodejs

      # GUI
      ghostty
      discord

      open-vm-tools

      biome
      alejandra

      pnpm

      go
      erlang_28
      pkgs.erlang-language-platform
    ]
    ++ [
      #inputs.zig.packages.${system}.master
      inputs.jsonc_fmt.packages.${system}.default
      inputs.iroha.packages.${system}.default
      inputs.self.packages.${system}.efmt
    ];

  #--------------------------------------------------
  # dotfiles
  #--------------------------------------------------
  xdg.configFile = {
    "nvim/lua".source = ./nvim;
    "ghostty/config".text = builtins.readFile ./ghostty.linux;
    "niri/config.kdl".source = ./niri/niri.kdl;
  };

  #--------------------------------------------------
  # Programs
  #--------------------------------------------------
  programs.bash = {
    enable = true;
    shellAliases = shellAliases;
  };

  programs.fish = {
    enable = true;
    shellAliases = shellAliases;
    shellInit = ''
      set -gx PATH $HOME/.cache/rebar3/bin $PATH
    '';
    functions = {
      btconnect = {
        description = "Connect to Bluetooth";
        body = builtins.readFile ./fish/bluetooth-connect.fish;
      };
    };
  };

  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ./starship.toml;
  };

  #programs.zed-editor = {
  #  enable = true;
  #  };

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
    extraLuaConfig = lib.fileContents ./nvim/init.lua;

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
      rust-analyzer
      gopls
    ];
  };

  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions;
        [
          vscode-icons-team.vscode-icons
          vscodevim.vim
          golang.go
          bbenoist.nix
          biomejs.biome
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "moonbit-lang";
            publisher = "moonbit";
            version = "0.1.2025110702";
            sha256 = "sha256-1LB9I8vTutRdwYIxnKMT965hvAmsIK5W5fshclgkvUg=";
          }
        ];
      userSettings = {
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "biomejs.biome";
        "[javascript]" = {
          "editor.defaultFormatter" = "biomejs.biome";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "biomejs.biome";
        };
        "[json]" = {
          "editor.defaultFormatter" = "biomejs.biome";
        };
      };
    };
  };

  # Browser
  # programs.google-chrome.enable = true;
  programs.google-chrome = lib.mkIf (currentSystemName == "x86_64") {
    enable = true;
  };

  programs.firefox.enable = true;
}
