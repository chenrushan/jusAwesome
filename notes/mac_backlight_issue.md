in case backlight doesn't work properly

create /etc/X11/xorg.conf.d/20-intel.conf, add following lines

    Section "Device"
            Driver      "intel"
            Option      "Backlight"  "intel_backlight"
            Identifier "card0"
    EndSection

