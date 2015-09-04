#!/bin/sh

# Author: Rushan Chen
# Email: juscodit@gmail.com

appPath=$(pushd $(dirname $0) >/dev/null && pwd -P && popd >/dev/null)

# ======================================================================
# Util Functions
# ======================================================================

function Log()
{
    echo $1 | tee -a log
}

function ExitFail()
{
    echo $1
    exit 1
}

function IsPkgExist()
{
    local pkg=$1
    pacman -Q $pkg 2> /dev/null > /dev/null
    if [[ $? -eq 0 ]]; then
        echo 1
    else
        echo 0
    fi
}

function InstallPkg()
{
    local pkgs=("${!1}")
    
    for pkg in ${pkgs[@]}; do
        local exist=`IsPkgExist $pkg`
        if [[ $exist -eq 1 ]]; then
            continue
        fi
        Log "Installing $pkg ..."
        sudo pacman -S --noconfirm $pkg
        if [[ $? -ne 0 ]]; then
            ExitFail "[ERROR]: fail to install $pkg"
        fi
    done
}

function InstallPkgAUR()
{
    local pkgUrl=$1

    tgzName=${pkgUrl##*/}
    pkgName=${tgzName%%.*}

    exist=`IsPkgExist $pkgName`
    if [[ $exist -eq 1 ]]; then
        return
    fi

    Log "Installing $pkgName from AUR ..."
    pkgs=(wget)
    InstallPkg pkgs[@]

    Log " * Downloading from AUR ..."
    if [[ ! -e $tgzName ]]; then
        wget $pkgUrl
        if [[ $? -ne 0 ]]; then
            ExitFail "[ERROR]: fail to download $tgzName"
        fi
    fi
    Log " * Makepkging ..."
    if [[ ! -e $pkgName ]]; then
        tar zxvf $tgzName
        if [[ $? -ne 0 ]]; then
            ExitFail "[ERROR]: fail to extract $tgzName"
        fi
    fi
    cd $pkgName
    makepkg -sf
    if [[ $? -ne 0 ]]; then
        ExitFail "[ERROR]: fail to makepkg $pkgName"
    fi
    Log " * Installing ..."
    pkg=`ls *.xz`
    sudo pacman -U --noconfirm $pkg
    if [[ $? -ne 0 ]]; then
        ExitFail "[ERROR]: fail to install $pkgName"
    fi
    cd ..
    rm -f $tgzName
    rm -rf $pkgName
}

function InstallPkgAUR_Yaourt()
{
    local pkgs=("${!1}")
    
    for pkg in ${pkgs[@]}; do
        local exist=`IsPkgExist $pkg`
        if [[ $exist -eq 1 ]]; then
            continue
        fi
        Log "Installing $pkg ..."
        yaourt -S --noconfirm $pkg
        if [[ $? -ne 0 ]]; then
            ExitFail "[ERROR]: fail to install $pkg"
        fi
    done
}

function DownloadFileTo()
{
    local url=$1
    local dest=$2

    if [[ -e $dest ]]; then
        return
    fi
    pkgs=(wget)
    InstallPkg pkgs[@]
    sudo wget $url -O $dest
    if [[ $? -ne 0 ]]; then
        ExitFail "[ERROR]: fail to download $url to $dest"
    fi
}

function DownloadFile()
{
    local url=$1
    DownloadFileTo $url "."
}

function InstallOpenboxTheme()
{
    local themeName=$1

    themeDir=$HOME/.themes
    if [[ ! -e $themeDir ]]; then
        mkdir $themeDir
        if [[ $? -ne 0 ]]; then
            ExitFail "[ERROR]: fail to create $themeDir"
        fi
    fi
    if [[ ! -e $themeDir/$themeName ]]; then
        Log "Installing theme $themeName ..."
        tar zxvf conf/${themeName}.tgz
        if [[ $? -ne 0 ]]; then
            ExitFail "[ERROR]: fail to extract theme $themeName"
        fi
        mv $themeName $themeDir
    fi
}

function DeleteSvnInfo()
{
    local dir=$1
    if [[ ! -d $dir ]]; then
        return
    fi
    find $dir -type d -name '*svn*' -exec rm -rf {} \; 2> /dev/null > /dev/null
}

# ======================================================================
# Enviroment Construction Functions
# ======================================================================

function Awesome()
{
    # install X server
    pkgs=(xorg-server xorg-server-utils xorg-xinit)
    InstallPkg pkgs[@]

    # install awesome wm
    pkgs=(awesome)
    InstallPkg pkgs[@]

    # install composite manager
    pkgs=(compton-git)
    InstallPkgAUR_Yaourt pkgs[@]

    # install packages for gtk2, gtk3 theme
    pkgs=(lxappearance gnome-themes-standard)
    InstallPkg pkgs[@]
}

# Yaourt is a great tool for installing package from AUR
function Yaourt()
{
    # dependency package
    pkgs=(yajl)
    InstallPkg pkgs[@]

    # dependency package
    pkg='https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz'
    InstallPkgAUR $pkg

    pkg='https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz'
    InstallPkgAUR $pkg
}

function Fonts()
{
    # all the following fonts are necessary in order for all applications
    # to display font (including Chinese font) properly.

    # dejavu (a useful font)
    fonts=(ttf-dejavu terminus-font)
    InstallPkg fonts[@]

    # Chinese fonts
    fonts=(ttf-arphic-uming ttf-arphic-ukai opendesktop-fonts)
    InstallPkg fonts[@]

    fonts=(
        monaco-linux-font
        ttf-ms-fonts # to solve firefox font rendering problem on certain pages like Google
        ttf-vista-fonts # including consolas
    )
    InstallPkgAUR_Yaourt fonts[@]

    xset +fp /usr/share/fonts/local
    xset fp rehash
}

function NetworkManager()
{
    pkgs=(networkmanager networkmanager-openconnect gnome-keyring network-manager-applet xfce4-notifyd)
    InstallPkg pkgs[@]

    sudo systemctl enable NetworkManager.service
    sudo systemctl start NetworkManager.service
}

# This app can convert latex functions to SVG format
function Inkscape()
{
    pkgs=(inkscape textlive-core textlive-bin pstoedit dvips ghostscript)
    InstallPkg pkgs[@]
}

function Apps()
{
    apps=(
        xorg-xbacklight # used to ajust the brightness of backlight
        rxvt-unicode
        xsel # copy & paste on command line
        feh # image viewerh
        vim # editor
        tint2 # a great panel with great document
        tmux # a replacement of screen
        sunpinyin # replacement of scim and scim-pinyin
        sunpinyin-data
        flashplugin
        subversion
        xorg-xprop # get window property by clicking on it
        wmctrl # enables you to control your WM from command line
        mplayer # video player
        alsa-utils # used to ajust the master volume
        xorg-xev # to capture the event generated by keyboard and mouse
        jre7-openjdk # java runtime env which I choose to use the open source version
        unrar
        openssh
        openconnect # cisco vpn client
        youtube-dl # youtube video downloader
        bash-completion # smart bash completion
        apvlv # lightweight vim-like pdf viewer
        virtualbox # virtual machine
        virtualbox-host-modules
        qt4
        pidgin # for google talk
        imagemagick # contain "import" command which is used to take screenshot
        gphoto2 # to copy image from iphone
        icedtea-web # java support for web browser
        gdb # debugger
        valgrind # debugger
        clang # for auto-complete
        gpick # color picker
        mpd # music player daemon
        mpc # music player client
        xlockmore # screen locker
        lm_sensors
        arandr # frontend of xrandr which is for multiple screen display
        evince # pdf reader
        cmake
        fcitx # input method
        fcitx-googlepinyin
        fcitx-libpinyin
    )
    InstallPkg apps[@]

    aur_apps=(
        # xseticon # xseticon enables you to set icon for an app at runtime
        equalx # to write equation
        # dropbox-experimental # file sharing service
        # kompozer # Kompozer is for WYSIWYG html editing
        grabc # command line tool to get pixel color on screen
        vim-clang-complete-git # for auto-complete
        zukitwo-themes # many gtk2 and gtk3 themes
        google-chrome # replacement of firefox
    )
    
    InstallPkgAUR_Yaourt aur_apps[@]

    Log "=================================================="
    Log "Link /usr/bin/python to /usr/bin/python3"
    Log "=================================================="
    # sudo ln -s /usr/bin/python3 /usr/bin/python
    # if [[ $? -ne 0 ]]; then
    #     ExitFail "[ERROR]: fail to link /usr/bin/python"
    # fi
}

function Goagent()
{
    # goagent is important for svn and web-browsing
    # NOTE that the gevent package should be 1.0dev (or 1.0rc) at the moment
    # which is same as what comes with Windows and Mac
    pkgs=(python2 python2-gevent-beta python2-pyopenssl)
    InstallPkg pkgs[@]

    if [[ -e /usr/bin/python ]]; then
        Log "=================================================="
        Log "REMOVE soft link /usr/bin/python"
        Log "=================================================="
        sudo rm /usr/bin/python
    fi

    # initialize for goagent, this may be needed in some situations
    local dir=$HOME/.pki/nssdb/
    if [[ ! -e $dir ]]; then
        mkdir -p $dir
        if [[ $? -ne 0 ]]; then
            ExitFail "[ERROR]: fail to create $dir"
        fi
        echo "[*] just input empty password below"
        certutil -d $dir -N
        if [[ $? -ne 0 ]]; then
            ExitFail "[ERROR]: fail to run certutil"
        fi
    fi
}

function LinkConf()
{
    rm /home/juscodit/.bashrc
    ln -s /home/juscodit/jusAwesome/conf/.Xdefaults /home/juscodit/.Xdefaults
    ln -s /home/juscodit/jusAwesome/conf/.bashrc /home/juscodit/.bashrc
    ln -s /home/juscodit/jusAwesome/conf/.vim/ /home/juscodit/.vim
    ln -s /home/juscodit/jusAwesome/conf/.vimrc /home/juscodit/.vimrc
    ln -s /home/juscodit/jusAwesome/conf/.terminfo/ /home/juscodit/.terminfo/
    ln -s /home/juscodit/jusAwesome/conf/.compton.conf /home/juscodit/.compton.conf
    ln -s /home/juscodit/jusAwesome/conf/.config/awesome/ /home/juscodit/.config/awesome/
    ln -s /home/juscodit/jusAwesome/conf/.fonts/ /home/juscodit/.fonts/
    ln -s /home/juscodit/jusAwesome/conf/.tmux.conf /home/juscodit/.tmux.conf
}

function TODO()
{
    Log "=================================================="
    Log "TODO:"
    Log "[*] Change gtk them with lxappearance"
    Log "[*] run sensors-detect"
    Log "[*] change the wireless interface in .conkyrc"
    Log "[*] change your qt app appearance with qtconfig-qt4, it has option to"
    Log "    utilize the GTK theme"
    Log "[*] goagent is in repository. You may need to enable community-test in"
    Log "    /etc/pacman.conf to install the newest version. Note that you'd"
    Log "    better cp goagent from /usr/share/ to your home directory, goagent"
    Log "    would create file under its dir at runtime, and it reqiures root"
    Log "    permission if you run it from /usr/share/. So copy to your home and"
    Log "    run it there, it will save you from running as sudo."
    Log "[*] add CA.crt of goagent to global certificate db as: (or youtube-dl won't work)"
    Log "    # mkdir /usr/local/share/ca-certificates/"
    Log "    # cp /usr/share/goagent/local/CA.crt /usr/local/share/ca-certificates/"
    Log "    # update-ca-certificates"
    Log "[*] add vboxdrv to /etc/modules-load.d/vboxdrv.conf"
    Log "[*] add snd-pcm-oss to /etc/modules-load.d/snd.conf so that conky can"
    Log "    display sound volume"
    Log "[*] install AutoHotkey in vbox windows and make it start at boot"
    Log '[*] put conf/AutoHotkey.ahk in windows'
    Log '    C:\Documents and Settings\Administrator\My Documents'
    Log "[*] see manual section of https://wiki.archlinux.org/index.php/OpenConnect"
    Log "    to setup openconnect"
    Log "[*] run hwclock -s --localtime if your time is not correct"
    Log "[*] Note that the cpuid argument to the '\${cpu}' object of .conkyrc"
    Log "    refers to the virtual processor, not the pysical core of your cpu."
    Log "    Check /proc/cpuinfo, if you see 'ht' in flags, then your cpu has"
    Log "    hyperthreading enabled which means you'll have multiple virtual"
    Log "    processor in each pysical core, and you should modify .conkyrc"
    Log "    accordingly to display the right cpu usage."
    Log "[*] run tic for terminfo"
    Log "=================================================="
}

function CreateOpenboxEnv()
{
    sudo pacman -Sy
    if [[ $? -ne 0 ]]; then
        ExitFail "[ERROR]: fail to update package database"
    fi

    Yaourt
    Awesome
    Fonts
    NetworkManager
    Apps
    LinkConf

    TODO
}

CreateOpenboxEnv

