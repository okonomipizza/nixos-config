{ lib, ... }:
{
  wayland.windowManager.hyprland.settings = {
    env = [
      "GTK_IM_MODULE, fcitx"
      "QT_IM_MODULE, fcitx"
      "XMODIFIERS, @im=fcitx"
    ];
    exec-once = [
      "fcitx5 -D"
      "hyprpaper"
    ];

    input = {
      repeat_delay = 300;
      repeat_rate = 30;
      follow_mouse = 1;
      sensitivity = lib.mkDefault (0.6);
    };
    general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 2;
    };

    decoration = {
      rounding = 10;
      blur = {
        enabled = true;
	size = 3;
	passes = 1;
	xray = true;
	ignore_opacity = true;
	new_optimizations = true;
      };
    };
    animations = {
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      animation = [
        "windows, 1, 4, myBezier, slide"
	    "layers, 1, 4, myBezier, fade"
	    "border, 1, 5, default"
	    "fade, 1, 5, default"
        "workspaces, 1, 6, default"
      ];
    };

    misc = {
      disable_hyprland_logo = true;
    };
    master = {
      new_status = "slave";
    };
  };
}
