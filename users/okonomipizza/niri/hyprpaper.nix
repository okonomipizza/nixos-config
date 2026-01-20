{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [pkgs.hyprpaper];
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    ipc = on
    splash = false

    preload = ~/Downloads/azuiro.jpeg
    wallpaper = ,~/Downloads/azuiro.jpeg
  '';
}
