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
"                              vim sessions
" (by http://www.terminally-incoherent.com/blog/2013/04/29/vim-sessions/)
"-------------------------------------------------------------------------------

let g:session_dir = $HOME."/.vim/sessions"
 
" Save sessions whenever vim closes
" autocmd VimLeave * call SaveSession()
 
" Saves the session to session dir. Creates session dir if it doesn't
" yet exist. Sessions are named after servername paameter
function! SaveSession()

  " get the server (session) name
  let s = v:servername

  " create session dir if needed
  if !isdirectory(g:session_dir)
    call mkdir(g:session_dir, "p")
  endif

  " save session using the server name
  execute "mksession! ".g:session_dir."/".s.".session.vim"
endfun

" Load session when vim is opened
" autocmd VimEnter * nested call OpenSession()

" Open a saved session if there were no file-names passed as arguments
" The session opened is based on servername (session name). If there
" is no session for this server, none will be opened
function! OpenSession()

  " check if file names were passed as arguments
  if argc() == 0

    let sn = v:servername
    let file = g:session_dir."/".sn.".session.vim"

    " if session file exists, load it
    if filereadable(file)
      execute "source ".file
    endif
  endif
endfunc

"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"                              set some autocmds
"-------------------------------------------------------------------------------

au FileType c,cpp,java setlocal cindent
au FileType tex,plaintex setlocal shiftwidth=2 tabstop=2
au FileType python setlocal shiftwidth=2 tabstop=2
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
inoremap <C-j> /*  */<left><left><left>
imap <C-l> <esc><C-l>zza
inoremap <C-e> <end>
inoremap <C-b> <left>
inoremap <C-f> <right>

nnoremap <C-p> :bprev<cr>
nnoremap <C-n> :bnext<cr>
nnoremap t :e 
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
hi Comment cterm=italic,bold ctermfg=65
" make vim background transparent
hi Normal ctermfg=254 ctermbg=none
" 22, 23, 24, 29, 36
" 22 good for green scheme
hi ColorColumn ctermbg=22

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
" good candidates 'laederon', 'lucius', 'understated', 'wombat' 'bubblegum'
" 'bubblegum' is good for green scheme
" 'lucius' is good for black scheme
let g:airline_theme = 'bubblegum'

" ctrlp config
let g:ctrlp_map = '<C-i>'
let g:ctrlp_custom_ignore = {
      \ 'dir': '\.git$\|\.yardoc\|public$|log\|tmp$\|target$\|project$',
      \ 'file': '\v\~$|\.(class|o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
      \ }
" nnoremap <C-i> :CtrlPBuffer<cr>

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

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
nnoremap <leader>d :YcmCompleter GoTo<CR>
set previewheight=1
set splitbelow

" so that starting vim doesn't overwrite tmux theme
let g:airline#extensions#tmuxline#enabled = 0

let g:NERDTreeWinSize = 25

