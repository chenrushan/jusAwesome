由于 screen 无法正常显示 italic font，我转向了 tmux，tmux 默认也不能正常显示 italic font，根源在于 terminfo 文件

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

也就是能不能显示 italic font 就看你有没有往 terminfo 加相应的功能。tmux 默认使用的 terminfo 是 screen，这个 terminfo 里没把这个功能加上，所以我们就需要创建一个带这个功能的 terminfo，具体过程如下，整个流程参考的是[这个](https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/)

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

对于 remote server，如果你想它跟你本地的表现一模一样，你就需要一个相同的 terminfo 文件，做法是首先导出本地的 terminfo 文件，运行命令

    infocmp SOME_TERMINFO > SOME_TERMINFO.terminfo

infocmp 会完整得把整个 terminfo 导出，我们上面创建的 terminfo 是在 screen-256color 基础添加了一个小功能，infocmp 则是完整得导出所有的东西。然后把这个 terminfo copy 到 remote server，同样在 remote server 运行 tic 命令即可，当然你的 .vimrc, .tmux.conf 也得是一样的了

