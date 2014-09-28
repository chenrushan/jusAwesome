由于 screen 无法正常显示 italic font，我转向了 tmux，tmux 默认也不能正常显示 italic font，根源在于 terminfo 文件

----------

根据 [tldp.org](http://tldp.org/HOWTO/Text-Terminal-HOWTO-16.html)，所谓的 terminfo 指的是

    Terminfo (formerly Termcap) is a database of terminal capabilities and more.
    For every (well almost) model of terminal it tells application programs what
    the terminal is capable of doing. It tells what escape sequences (or control
    characters) to send to the terminal in order to do things such as move the
    cursor to a new location, erase part of the screen, scroll the screen, change
    modes, change appearance (colors, brightness, blinking, underlining, reverse
    video etc.). After about 1980, many terminals supported over a hundred
    different commands (some of which take numeric parameters).
    
    One way in which terminfo gives the its information to an application program
    is via the "ncurses" functions that a programmer may put into a C program.
    For example, if a program wants to move the cursor to row 3, col 6 it simply
    calls: move(3,6). The move() function (part of ncurses) knows how to do this
    for your terminal (it has read terminfo). So it sends the appropriate escape
    sequence to the terminal to make this particular move for a certain terminal.
    Some programs get info directly from a terminfo files without using ncurses.
    Thus a Linux package that doesn't require ncurses may still need a terminfo
    file for your terminal.

说白了就是 terminfo 决定了一个终端能做哪些事情，具有哪些能力，并且告诉应用程序：“如果你想完成 XXX 任务，你需要发 YYY 命令给我”

termcap 就是 terminal capability 的简写，老的 termcap 文件把所有终端的配置都放在一个文件中，新的 terminfo 的方式则把不同的配置分到不同的文件中

----------

因此能不能显示 italic font 就看你有没有往 terminfo 加相应的功能。tmux 默认使用的 terminfo 是 screen，这个 terminfo 里没把这个功能加上，所以我们就需要创建一个带这个功能的 terminfo，具体过程如下，整个流程参考的是[这个](https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/)

1. create a file named `screen-256color-italic.terminfo` which contains

        # A screen-256color based TERMINFO that adds the escape sequences for italic.
        screen-256color-italic|screen with 256 colors and italic,
          sitm=\E[3m, ritm=\E[23m,
          use=screen-256color,

2. compile this file

        tic screen-256color-italic.terminfo

    this will create a file `~/.terminfo/s/screen-256color-italic`

3. change the TERM setting of tmux by adding the following line to `~/.tmux.conf`

        set -g default-terminal "screen-256color-italic"

----------

对于 remote server，如果你想它跟你本地的表现一模一样，你就需要一个相同的 terminfo 文件，做法是首先导出本地的 terminfo 文件，运行命令

    infocmp SOME_TERMINFO > SOME_TERMINFO.terminfo

infocmp 会完整得把整个 terminfo 导出，我们上面创建的 terminfo 是在 screen-256color 基础添加了一个小功能，infocmp 则是完整得导出所有的东西。然后把这个 terminfo copy 到 remote server，同样在 remote server 运行 tic 命令即可，当然你的 .vimrc, .tmux.conf 也得是一样的了

还要注意的是，如果 remote server 上的 bash 不是使用 terminfo 而是使用古老的 termcap 的话，你在 tmux 中配置 `set -g default-terminal "screen-256color-italic"` 会带来问题，表现就是你发现按 `Ctrl-l` 不再 clear screen，如果你一行命令敲得长了一点，终端的渲染就出问题等等，问题的原因是 bash 读取的是 termcap，而 termcap 中没有包含你的 screen-256color-italic，这样 bash 为了完成某某个渲染任务发出的命令就和 tmux 期望得到的不一样，因此很多任务就没法正常完成

判断一个 bash 使用的是 terminfo 还是 termcap 只要运行 `ldd bash_command`，如果你看到像 

    libtermcap.so.2 => /lib64/libtermcap.so.2

则这个 bash 读的就是 termcap，如果看到

    libncurses.so.5 => /usr/lib64/libncurses.so.5

则这个 bash 读的就是 terminfo

由于在 remote server 上通常你没有权限去改变系统使用的 bash，所以只能自己装一个在 home 目录下

    ./configure --with-curses --prefix=/path/to/bash/ && make && make install

这里 `--with-curses` 选项就是指定让 bash 使用 libncurses，不然默认还是使用 libtermcap

----------

tmux 默认启动的是 login shell，login shell 和 non-login shell 的不同参考下面 (from [here](http://serverfault.com/questions/261802/profile-vs-bash-profile-vs-bashrc))

    .bash_profile and .bashrc are specific to bash, whereas .profile is read by
    many shells in the absence of their own shell-specific config files. (.profile
    was used by the original Bourne shell.) .bash_profile or .profile is read by
    login shells, along with .bashrc; subshells read only .bashrc. (Between job
    control and modern windowing systems, .bashrc by itself doesn't get used much.
    If you use screen or tmux, screens/windows usually run subshells instead of
    login shells.)
    
    The idea behind this was that one-time setup was done by .profile (or
    shell-specific version thereof), and per-shell stuff by .bashrc. For example,
    you generally only want to load environment variables once per session instead
    of getting them whacked any time you launch a subshell within a session,
    whereas you always want your aliases (which aren't propagated automatically
    like environment variables are).
    
    Other notable shell config files:
    
    /etc/bash_profile (fallback /etc/profile) is read before the user's .profile
    for system-wide configuration, and likewise /etc/bashrc in subshells (no
    fallback for this one). Many systems including Ubuntu also use an /etc/profile.d
    directory containing shell scriptlets, which are . (source)-ed from
    /etc/profile; the fragments here are per-shell, with *.sh applying to all
    Bourne/POSIX compatible shells and other extensions applying to that
    particular shell.

由于 powerline 的缘故，我不希望 tmux 执行 .bash_profile，因此我就需要让 tmux start non-login shell，在 .tmux.conf 加入下面这行即可实现

    set -g default-command bash
