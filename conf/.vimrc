"*******************************************************************************
" Author: Chen Rushan
" E-Mail: juscodit@gmail.com
"*******************************************************************************

"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"                            define some functions
"-------------------------------------------------------------------------------

" This function creates a tag file in the root directory of a
" project, which contains only non-static tags present in
" all source files, but for this function to work, a file called
" '.crsproj' needs to be created in the root directory
fun! CrsCtagsProj()
  let prevwd = getcwd()

  " first we cd to the directory containing currently-editing file
  exec "cd " . expand("%:p:h")

  while filereadable(".crsproj") == 0
    cd ..
    if getcwd() == "/"
      break
    endif
  endwhile

  let crsproj = getcwd()

  " I assume that no project will use '/' as its root directory
  if crsproj == "/"
    echo "\nno .crsproj is found\n"
    return
  endif

  exec "cd " . prevwd
  exec "sil !cd " . crsproj . ";"
        \. "find -name '*.[hc]' -print0 -o -name '*.cpp' -print0 |"
        \. "xargs -0 ctags --fields=+aS --extra=+q --file-scope=no &"
endfun

"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"                         set some internal variables
"-------------------------------------------------------------------------------

let g:html_indent_tags=""
let mapleader=","


"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"                              set some autocmds
"-------------------------------------------------------------------------------

au FileType c,cpp,java setlocal cindent
au FileType tex,plaintex setlocal shiftwidth=4
au FileType tex,plaintex setlocal tabstop=4
au FileType python setlocal shiftwidth=2 tabstop=2
au FileType java setlocal shiftwidth=2 tabstop=2
au FileType vim setlocal shiftwidth=2 tabstop=2

"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"                             some basic setting
"-------------------------------------------------------------------------------

set nocompatible
set wildmenu
set nu
set nowrap
set showcmd
set tabstop=4
set shiftwidth=4
set autoindent
set hlsearch
set showmatch
set ruler
set et
set cursorline
set linebreak
set incsearch
set mousehide
set nobackup
set dictionary+=/usr/share/dict/words
set fileencodings=ucs-bom,utf-8,gb2312
set laststatus=2
" this will facilitate the use of tags file when programming, since
" generally a tags file is in the same directory as the current source
" file, set autochdir help you avoid changing current working directory
" manually every time you switch buffer
set autochdir
" the final '/' will cause vim to search tags file up to root directory
" until a tags file is found
set tags=./tags,../tags,tags
set tags+=~/.vim/tags/ctags
set completeopt=menuone,menu,longest
set complete=.,w,b,u
set backspace=indent,eol,start
" set a mark on column 80
set colorcolumn=80

" Turn backup off
set nobackup
set nowb
set noswapfile
set pastetoggle=<leader>e

lan C
syntax on
filetype plugin on
filetype plugin indent on
runtime! ftplugin/man.vim

"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"                               set hot keys
"-------------------------------------------------------------------------------

inoremap " ""<left>
inoremap [ []<left>
inoremap ( ()<left>
inoremap { {}<left>
inoremap <C-j> /*  */<left><left><left>
imap <C-l> <esc><C-l>zza
inoremap <C-e> <end>
inoremap <C-b> <left>
inoremap <C-f> <right>

nnoremap <C-p> :bprev<cr>
nnoremap <C-n> :bnext<cr>
nnoremap t :e 
nnoremap <C-L> :nohl<cr><C-L>
nnoremap <C-k> :bd<cr>
nnoremap <leader>v :vsp<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>Q :qa<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>W :wq<cr>
nnoremap <leader>s :saveas 
nnoremap <leader>ac I/* <esc>A */<esc>
" since autochdir is set, we don't need to first cd to the directory
" of current file before running ctags
nnoremap <leader>t :sil !find -maxdepth 1 -name '*.[ch]' -print0 -o
         \ -name '*.cpp' -print0 \| xargs -0 ctags --fields=+aS --extra=+q &<cr>
nnoremap <leader>T :call CrsCtagsProj()<cr>

" this map causes the visual selected text yanked by pressing
" 'Y' to be sent to the PRIMARY selection, so that you can paste
" that text to X apps using middle mouse button
vnoremap Y y:call system("xclip -i", getreg("\""))<cr>

" cursor move up/down one row instead of one line
nnoremap j gj
nnoremap k gk

set t_Co=256
colorscheme molokai

" some modification to molokai

" here's a list of prefered comment color: 65, 66, 72, 73, 101, 102, 109
hi Comment cterm=italic,bold ctermfg=65
" make vim background transparent
hi Normal ctermfg=254 ctermbg=none
hi ColorColumn ctermbg=238

set concealcursor=inv
set conceallevel=2
let g:clang_auto_select=1
let g:clang_complete_auto=1
let g:clang_complete_copen=1
let g:clang_complete_hl_errors=1
let g:clang_snippets=1
let g:clang_periodic_quickfix=0
let g:clang_complete_copen=1
let g:clang_snippets_engine='clang_complete'
set completeopt=menu,longest

" set rtp+=/usr/lib/python3.4/site-packages/Powerline-beta-py3.4.egg/powerline/bindings/vim/

" enable persistent undo (work for vim >= 7.3)
set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories, dir should be created manually
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

" enable pathogen
execute pathogen#infect()

" airline config
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'bubblegum'

" ctrlp config
let g:ctrlp_map = '<c-i>'
let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

