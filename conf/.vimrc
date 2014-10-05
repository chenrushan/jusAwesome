"*******************************************************************************
" Author: Chen Rushan
" E-Mail: juscodit@gmail.com
"*******************************************************************************

"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"                            define some functions
"-------------------------------------------------------------------------------

" This function loads skeleton file if it exists
fun! CrsLoadSkeleton(file_suffix)
        let file = $HOME . "/.vim/skeleton/skeleton." . a:file_suffix
        if filereadable(file)
                exe "0r " . file
        endif
endfun

" This function adds curly braces according to different
" situations
fun! CrsAddCurlyBraces()
      let len = len(getline("."))
      if len != 0
              let cw = expand("<cword>") "get word under cursor
              if cw =~ ")$"
                      exe "normal! A {\n}\<esc>kA\n \<bs>\<esc>"
              else
                      exe "normal! a{}\<esc>h"
              endif
      else
              exe "normal! i{\n}\n\<esc>kkA\n \<bs>\<esc>"
      endif
endfun

fun! CrsLastMod()
        if line("$") > 20
                let l = 20
        else
                let l = line("$")
        endif
        exe "1," . l . "s/Last modified:.*/Last modified: " 
                         \ . strftime("%Y %b %d %X") . "/e"
endfun

" This function is responsible for compiling source file with gcc,
" the position of final binary is decided in the following order:
"    1. See if a directory called 'bin' exists on the upper level
"    2. See if a directory called 'bin' exists on the same level
"    3. Put the binary under the same directory as source file
fun! CrsCompileWithGcc(opt)
        let abso_path = expand("%:p:h")

        " Check where to put the final binary
        if isdirectory(abso_path . "/../bin/")
                let bin_dir = abso_path . "/../bin/"
        elseif isdirectory(abso_path . "/bin/")
                let bin_dir = abso_path . "/bin/"
        else
                let bin_dir = abso_path . "/"
        endif

        let out_bin = bin_dir . expand("%:t:r:gs/_/-/")

        " NOTE: Don't forget 'shellescape', every time you wanna invoke
        "       some shell command from vim, don't forget to run 
        "       shellescape first on the directory
        exe "!gcc -o " . shellescape(out_bin) . " " . shellescape("%")
                                                \ . " " . a:opt
endfun

fun! CrsCompileTex(opt)
        let tex_dir_name = expand("%:p:h:t")
        
        if tex_dir_name == "tex"
                let out_dir = expand("%:p:h:h")
        else
                let out_dir = expand("%:p:h")
        endif

        exe "!pdflatex -output-directory " . shellescape(out_dir) . " " .
                \ shellescape("%") 
        
        if a:opt == ""
                exe "!rm " . shellescape(out_dir) . "/*.{aux,log,out,toc}"
        endif
endfun

" Call different CrsCompile function according to current filetype
fun! CrsCompile(opt)
        if &filetype == "tex" || &filetype == "plaintex"
                call CrsCompileTex(a:opt)
        elseif &filetype == "c"
                call CrsCompileWithGcc(a:opt)
        endif
endfun

" This function is almost the same as CrsCompileWithGcc() except for
" the last statement, the reason is obvious, since you need to run the
" program from the place where you put it when you compile the program
fun! CrsRunCProg()
        let abso_path = expand("%:p:h")

        if isdirectory(abso_path . "/../bin/")
                let bin_dir = abso_path . "/../bin/"
        elseif isdirectory(abso_path . "/bin/")
                let bin_dir = abso_path . "/bin/"
        else
                let bin_dir = abso_path . "/"
        endif

        let bin = bin_dir . "%:t:r:gs/_/-/"

        exe "!" . shellescape(bin)
endfun

fun! CrsRunTex()
        let pdfname = expand("%:p:t:s/tex$/pdf/")
        let tex_dir_name = expand("%:p:h:t")

        if tex_dir_name == "tex"
                let pdf_dir = expand("%:p:h:h")
        else
                let pdf_dir = expand("%:p:h")
        endif

        exe "sil !" . g:crs_pdfapp . " " . shellescape(pdf_dir)
                        \ . "/" . shellescape(pdfname) . "&"
endfun

" Execute according to current filetype
fun! CrsRun()
        if &filetype == "c"
                call CrsRunCProg()
        elseif &filetype == "tex" || &filetype == "plaintex"
                call CrsRunTex()
        endif
endfun

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

fun! CrsSmartTab()
       if pumvisible()
               return "\<c-n>"
       endif

       let curidx = col('.')
       let prevchar = strpart(getline('.'), curidx - 2, 1)

       if prevchar == "/"
               return "\<c-x>\<c-f>"
       elseif prevchar =~ "^[ \t]*$"
               return "\<tab>"
       else
               return "\<c-x>\<c-o>"
endfun

fun! CrsCallMake()
        let prevwd = getcwd()

        while filereadable("Makefile") == 0
                cd ..
                if getcwd() == "/"
                        break
                endif
        endwhile

        if getcwd() == "/"
                echo "\nno Makefile is found\n"
                return
        endif

        let maked = getcwd()

        exec "cd " . prevwd
        exec "sil !(cd " . maked . "; make)"
endfun

"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"                         set some internal variables
"-------------------------------------------------------------------------------

let g:html_indent_tags=""
let mapleader=","


"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"                              set some autocmds
"-------------------------------------------------------------------------------

au BufNewFile *.c call CrsLoadSkeleton("c")
au BufNewFile *.py call CrsLoadSkeleton("py")
au BufNewFile *.sh call CrsLoadSkeleton("sh")
au BufNewFile *.java call CrsLoadSkeleton("java")
au FileType c,cpp,java setlocal cindent
au BufNewFile *.pl call CrsLoadSkeleton("pl")
au BufNewFile *.tex call CrsLoadSkeleton("tex")
au FileType tex,plaintex setlocal shiftwidth=4
au FileType tex,plaintex setlocal tabstop=4
au BufEnter *.c,*.pl,*.cpp,*.java inoremap <buffer> { <esc>:call CrsAddCurlyBraces()<cr>a
au FileType python setlocal shiftwidth=2 tabstop=2
au FileType java setlocal shiftwidth=2 tabstop=2


"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"                             some basic setting
"-------------------------------------------------------------------------------

set nocompatible
set wildmenu
set nu
set nobackup
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

lan C
syntax on
filetype plugin on
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
inoremap <expr> <tab> CrsSmartTab()

nnoremap <C-p> gT
nnoremap <C-n> gt
nnoremap t :tabnew 
nnoremap <C-L> :nohl<cr><C-L>
nnoremap <C-k> :tabclose<cr>
nnoremap <f7> <esc>:setlocal spell spelllang=en_us<cr>
nnoremap <f8> <esc>:setlocal nospell<cr>
nnoremap <f2> <C-w>w
nnoremap <f10> :w<cr>:call CrsCompile("-g")<cr>
nnoremap <f11> :w<cr>:call CrsCompile("")<cr>
nnoremap <f12> :call CrsRun()<cr>
nnoremap <f1> :90vsp<cr><c-w><c-w>:new<cr><c-w>w:q<cr><c-w><c-w>
nnoremap <leader>v :vsp<cr>
nnoremap <leader>e :e 
nnoremap <leader>q :q<cr>
nnoremap <leader>Q :qa<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>W :wq<cr>
nnoremap <leader>s :saveas 
nnoremap <leader>ac I/* <esc>A */<esc>
nnoremap <leader>m :make %:r:gs/_/-/<cr>
" since autochdir is set, we don't need to first cd to the directory
" of current file before running ctags
nnoremap <leader>t :sil !find -maxdepth 1 -name '*.[ch]' -print0 -o
         \ -name '*.cpp' -print0 \| xargs -0 ctags --fields=+aS --extra=+q &<cr>
nnoremap <leader>T :call CrsCtagsProj()<cr>
nnoremap <leader>m :call CrsCallMake()<cr>

" this map causes the visual selected text yanked by pressing
" 'Y' to be sent to the PRIMARY selection, so that you can paste
" that text to X apps using middle mouse button
vnoremap Y y:call system("xclip -i", getreg("\""))<cr>

set t_Co=256
colorscheme molokai

" some modification to molokai

" here's a list of prefered comment color: 65, 66, 72, 73, 101, 102, 109
hi Comment cterm=italic,bold ctermfg=65
" make vim background transparent
hi Normal ctermfg=254 ctermbg=none
hi ColorColumn ctermbg=238

function! FoldExpr(num)
    if getline(a:num) =~? '^\s*if (err ==.*$'
        return '>1'
    endif
    if getline(a:num) =~? '^\s*}'
        return '<1'
    endif
    return foldlevel(a:num)
endfunction


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

set rtp+=/usr/lib/python3.4/site-packages/Powerline-beta-py3.4.egg/powerline/bindings/vim/

" enable persistent undo (work for vim >= 7.3)
set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories, dir should be created manually
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo
