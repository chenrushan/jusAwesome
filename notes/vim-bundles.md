#### Plugins

1. [Pathogen](https://github.com/tpope/vim-pathogen)

2. [Vim-airline](https://github.com/bling/vim-airline)

3. [Vim-fugitive](https://github.com/tpope/vim-fugitive)

4. [ctrlp](https://github.com/kien/ctrlp.vim)

5. [vim-scala](https://github.com/derekwyatt/vim-scala)

    only work with [FuzzyFinder](https://github.com/vim-scripts/FuzzyFinder) installed, which in turn needs [L9](https://github.com/vim-scripts/L9) to be installed

6. [vim-snippets](https://github.com/honza/vim-snippets)

    should use with [ultisnips](https://github.com/SirVer/ultisnips)

    vim-snippets just provides snippets
    ultisnips is the engine

7. [YouCompleteMe](https://github.com/Valloric/YouCompleteMe.git)

    * Clone YouCompleteMe from github

            cd .vim/bundle
            git submodule add https://github.com/Valloric/YouCompleteMe.git
            cd YouCompleteMe
            git submodule update --init --recursive

    * install cmake

    * Install YCM without clang-completer

            cd ~
            mkdir ycm_build
            cd ycm_build
            cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
            make ycm_support_libs
            rm -r ycm_build

    * Install YCM with clang-completer

        before running the following commands, install `libclang` on your system
        
            cd ~/.vim/bundle/YouCompleteMe/
            ./install.sh --clang-completer --system-libclang

        after that, add `.ycm_extra_conf.py`
        
    If you want to enable clang-completer support, see [YouCompleteMe github](https://github.com/Valloric/YouCompleteMe)

    Reference: [alexeyshmalko.com](http://www.alexeyshmalko.com/2014/youcompleteme-ultimate-autocomplete-plugin-for-vim/)

    YCM 有个很恶心的是，如果你的 .ycm_extra_conf.py 有问题，YCM 不提示错误就直接
    不工作了，有的时候你莫名其妙为什么 clang-completer 就不好使了

8. [tmuxline](https://github.com/edkolev/tmuxline.vim)

    Configure tmux status line from vim, and make tmux share the same theme as vim
