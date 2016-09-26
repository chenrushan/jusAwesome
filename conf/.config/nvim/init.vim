" Plugins
call plug#begin()
Plug 'Valloric/YouCompleteMe'
Plug 'majutsushi/tagbar'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimproc.vim'
"Plug 'edkolev/tmuxline.vim'
Plug 'vim-airline/vim-airline'
Plug 'fatih/vim-go'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

let mapleader=","

" YCM config
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
let g:ycm_complete_in_comments=1
let g:ycm_collect_identifiers_from_comments_and_strings=1
let g:ycm_add_preview_to_completeopt=1
let g:ycm_autoclose_preview_window_after_insertion=1
let g:ycm_confirm_extra_conf = 0
nnoremap <leader>d :YcmCompleter GoTo<CR>

" airline config
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 0
" good candidates 'laederon', 'lucius', 'understated', 'wombat', 'bubblegum', 'badwolf'
" 'bubblegum' is good for green scheme
" 'lucius' is good for black scheme
let g:airline_theme = 'laederon'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-q>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

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

" ============================================================

colorscheme monokai

au FileType c,cpp,java setlocal cindent
au FileType tex,plaintex setlocal shiftwidth=2 tabstop=2
au FileType python setlocal shiftwidth=4 tabstop=4
au FileType java setlocal shiftwidth=2 tabstop=2
au FileType lua setlocal shiftwidth=3 tabstop=3
au FileType vim setlocal shiftwidth=2 tabstop=2
au FileType javascript setlocal shiftwidth=2 tabstop=2
au BufNewFile,BufRead *.md setlocal filetype=markdown

set hidden " allows you to have unwritten changes to a file and open a new file
set smartcase " ignore case if search pattern is all lowercase
set history=1000

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

" this will facilitate the use of tags file when programming, since
" generally a tags file is in the same directory as the current source
" file, set autochdir help you avoid changing current working directory
" manually every time you switch buffer
set autochdir

" set a mark on column 80
set colorcolumn=80

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

nnoremap j gj
nnoremap k gk

" hi Comment cterm=italic,bold

set undofile                " Save undo's after file closes
set undodir=$HOME/.config/nvim/undo " where to save undo histories, dir should be created manually
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

