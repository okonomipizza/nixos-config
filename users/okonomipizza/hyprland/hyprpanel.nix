{ inputs, ... }:
{
  programs.hyprpanel = {
    enable = true;
    settings = {
      bar = {
        fontSize = 12;
        iconSize = 14;
      };
    };
  };
}
