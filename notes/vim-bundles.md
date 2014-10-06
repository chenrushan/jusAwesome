#### Plugins

1. [Pathogen](https://github.com/tpope/vim-pathogen)

2. [Vim-airline](https://github.com/bling/vim-airline)

3. [Vim-fugitive](https://github.com/tpope/vim-fugitive)

4. [ctrlp](https://github.com/kien/ctrlp.vim)

5. [vim-scala](https://github.com/derekwyatt/vim-scala)

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
            cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp"
            make ycm_support_libs
            rm -r ycm_build

    If you want to enable clang-completer support, see [YouCompleteMe github](https://github.com/Valloric/YouCompleteMe)

    Reference: [alexeyshmalko.com](http://www.alexeyshmalko.com/2014/youcompleteme-ultimate-autocomplete-plugin-for-vim/)

