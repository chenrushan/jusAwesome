"*******************************************************************************
" Author: Chen Rushan
" E-Mail: juscodit@gmail.com
"*******************************************************************************

" Plugins
call plug#begin()
Plug 'Valloric/YouCompleteMe'
Plug 'rdnetto/YCM-Generator'
Plug 'majutsushi/tagbar'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimproc.vim'
"Plug 'edkolev/tmuxline.vim'
Plug 'vim-airline/vim-airline'
Plug 'fatih/vim-go'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline-themes'
"Plug 'bbchung/Clamp'
call plug#end()

" airline config
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 0
" good candidates 'laederon', 'lucius', 'understated', 'wombat', 'bubblegum',
" 'badwolf'
" 'bubblegum' is good for green scheme
" 'lucius' is good for black scheme
let g:airline_theme = 'laederon'

" ctrlp config
let g:ctrlp_map = '<C-i>'
let g:ctrlp_custom_ignore = {
      \ 'dir': '\.git$\|\.yardoc\|public$|log\|tmp$\|target$\|project$',
      \ 'file': '\v\~$|\.(class|o|d|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
      \ }
" nnoremap <C-i> :CtrlPBuffer<cr>

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-q>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Solve the TAB key conflict between ycm and ultisnip
" Disable YCM's use of TAB key, instead cycle through completion with <C-N> and <C-P> keys.
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
let g:ycm_complete_in_comments=1
let g:ycm_collect_identifiers_from_comments_and_strings=1
let g:ycm_add_preview_to_completeopt=1
let g:ycm_autoclose_preview_window_after_insertion=1
let g:ycm_confirm_extra_conf = 0
nnoremap <leader>d :YcmCompleter GoTo<CR>
set previewheight=1
set splitbelow

" so that starting vim doesn't overwrite tmux theme
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#tabline#enabled = 1

let g:NERDTreeWinSize = 25

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#source('file,file/new,buffer,file_rec,line', 'matchers', 'matcher_fuzzy')
nnoremap <leader>z :<C-u>Unite -buffer-name=search -start-insert line<cr>
nnoremap <leader>f :UniteWithProjectDir -start-insert file_rec/async<CR>

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"

"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"                              set some autocmds
"-------------------------------------------------------------------------------

au FileType c,cpp,java setlocal cindent
au FileType tex,plaintex setlocal shiftwidth=2 tabstop=2
au FileType python setlocal shiftwidth=4 tabstop=4
au FileType java setlocal shiftwidth=2 tabstop=2
au FileType lua setlocal shiftwidth=3 tabstop=3
au FileType vim setlocal shiftwidth=2 tabstop=2
au FileType javascript setlocal shiftwidth=2 tabstop=2
au BufNewFile,BufRead *.md setlocal filetype=markdown
" au vimenter * NERDTree

" {{{
" the following script allows NERDTree to highlight current open file
"
" returns true iff is NERDTree open/active
" function! rc:isNTOpen()        
"   return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
" endfunction
" " calls NERDTreeFind iff NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
" function! rc:syncTree()
"   if &modifiable && rc:isNTOpen() && strlen(expand('%')) > 0 && !&diff
"     NERDTreeFind
"     wincmd p
"   endif
" endfunction
" au BufEnter * call rc:syncTree()
" }}}

"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"                             some basic setting
"-------------------------------------------------------------------------------

let g:html_indent_tags=""
let mapleader=","

set hidden " allows you to have unwritten changes to a file and open a new file
set smartcase " ignore case if search pattern is all lowercase
set history=1000
set visualbell " don't beep
set noerrorbells " don't beep
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

" from (http://vim.wikia.com/wiki/Single_tags_file_for_a_source_tree)
" The last semicolon is the key here. When Vim tries to locate the 'tags'
" file, it first looks at the current directory, then the parent directory,
" then the parent of the parent, and so on. (should work with 'set autochdir')
set tags=tags;

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
imap <C-l> <esc><C-l>zza
inoremap <C-e> <end>
inoremap <C-b> <left>
inoremap <C-f> <right>

nnoremap <C-p> :bprev<cr>
nnoremap <C-n> :bnext<cr>
" nnoremap t :e 
nnoremap <C-L> :nohl<cr><C-L>
nnoremap <C-k> :bp<cr>:bd #<cr>
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
nnoremap <leader>r :NERDTreeFind<cr><C-w>l

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
hi Comment cterm=italic,bold
" make vim background transparent
hi Normal ctermfg=254 ctermbg=none
" 22, 23, 24, 29, 36
" 22 good for green scheme
hi ColorColumn ctermbg=236
hi DiffAdd ctermbg=24
hi DiffChange ctermbg=96
hi DiffDelete ctermbg=52
hi DiffText ctermbg=161

" set rtp+=/usr/lib/python3.4/site-packages/Powerline-beta-py3.4.egg/powerline/bindings/vim/

" enable persistent undo (work for vim >= 7.3)
set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories, dir should be created manually
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

