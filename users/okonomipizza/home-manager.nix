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

  isDarwin = currentSystemName == "macbook";
  isLinux = currentSystemName == "x86_64" || currentSystemName == "vm-aarch64";

  shellAliases = {
    pn = "pnpm";
    ls = "ls -F";
    rm = "rm -i";
    cp = "cp -i";
    mvgk = "mv -i";
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
  ] ++ (lib.optionals isLinux [
    ./niri
  ]);
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
      yazi

      nodejs

      biome
      alejandra

      pnpm
      go
      erlang_28
      pkgs.erlang-language-platform
    ]
    ++ (lib.optionals (isLinux) [
      open-vm-tools
      inputs.ghostty.packages.${system}.default
      inputs.zig.packages.${system}.master
      inputs.jsonc_fmt.packages.${system}.default
      inputs.iroha.packages.${system}.default
      inputs.self.packages.${system}.efmt
      firefox
      man-pages
    ]) ++ (lib.optionals (isDarwin) [
      inputs.xpack-arm-gcc.packages.${system}.default
    ]);

  #--------------------------------------------------
  # dotfiles
  #--------------------------------------------------
home.sessionVariables = {
    # LANG = "en_US.UTF-8";
    # LC_CTYPE = "en_US.UTF-8";
    # LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";

    AMP_API_KEY = "op://Private/Amp_API/credential";
    OPENAI_API_KEY = "op://Private/OpenAPI_Personal/credential";
  } // (if isDarwin then {
    # See: https://github.com/NixOS/nixpkgs/issues/390751
    DISPLAY = "nixpkgs-390751";
  } else {});
  xdg.configFile = {
    "nvim/lua".source = ./nvim;
    "ghostty/config".text = builtins.readFile ./ghostty.linux;
    
  } // (lib.optionalAttrs isLinux {
    "niri/config.kdl".source = ./niri/niri.kdl;

  });

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
      set -gx PNPM_HOME $HOME/.local/share/pnpm
      if not contains $PNPM_HOME $PATH
        set -gx PATH $PNPM_HOME $PATH
      end
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
    settings = {
      user.name = "okonomipizza";
      user.email = "140386510+okonomipizza@users.noreply.github.com";
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
      # Syntax & Highlighting
      nvim-treesitter.withAllGrammars

      # LSP & Completion
      nvim-lspconfig
      blink-cmp

      # File Management
      oil-nvim

      # Navigation & Motion
      flash-nvim

      # UI & Appearance
      kanagawa-nvim
      lualine-nvim
      nvim-web-devicons

      snacks-nvim
      plenary-nvim
      nui-nvim
    ];

    extraPackages = with pkgs; [
      # LSP
      lua-language-server
      nixd
      rust-analyzer
      gopls
      clang-tools
      # Tools
            ripgrep
    ];
  };

  # Browser
  # programs.google-chrome.enable = true;
  programs.google-chrome = lib.mkIf (currentSystemName == "x86_64") {
    enable = true;
  };
}
