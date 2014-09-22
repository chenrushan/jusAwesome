1. sudo pacman -S networkmanager networkmanager-openconnect gnome-keyring network-manager-applet xfce4-notifyd

    * networkmanager: the service managing network under the hood
    * networkmanager-openconnect: for cisco VPN
    * gnome-keyring: for password
    * network-manager-applet: applet in the systray
    * xfce4-notifyd: for notification

2. run

        sudo systemctl enable NetworkManager.service
        sudo systemctl start NetworkManager.service
        nm-applet

    * the first command enables NetworkManager to start on boot
    * the second command starts NetworkManager on demand
    * the last command shows the applet on systray
