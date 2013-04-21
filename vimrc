set softtabstop=4
set expandtab
set number
set tabstop=8
set shiftwidth=4
set backspace=2
syntax on
set pastetoggle=<F2>
set smartindent
set incsearch
set ignorecase
set smartcase
set autoindent
filetype indent on
filetype plugin on
colorscheme desert
cmap w!! w !sudo tee >/dev/null %

" extra keywords.
autocmd FileType c syn keyword cType uint ulong ushort
autocmd FileType h syn keyword cType uint ulong ushort
autocmd FileType cc syn keyword cType uint ulong ushort
autocmd FileType cpp syn keyword cType uint ulong ushort
autocmd FileType hpp syn keyword cType uint ulong ushort
autocmd FileType c syn keyword cType u_int8_t u_int16_t u_int32_t u_int64_t
autocmd FileType h syn keyword cType u_int8_t u_int16_t u_int32_t u_int64_t
autocmd FileType cc syn keyword cType u_int8_t u_int16_t u_int32_t u_int64_t
autocmd FileType cpp syn keyword cType u_int8_t u_int16_t u_int32_t u_int64_t
autocmd FileType hpp syn keyword cType u_int8_t u_int16_t u_int32_t u_int64_t

" .wiki extention pages screw up and put <feff> byte-order without this
au BufWritePre * setlocal nobomb

" this is a hack to get svnvimdiff to highlight the tmp
" files as c files.
autocmd BufNewFile,BufRead *.tmp set ft=c

" it's an addiction now
imap jj <Esc>

" hopefully this is useful. do \w to save and go back to insert 
imap <Leader>w <Esc>:w<Return>
map <Leader>w :w<Return>

" so Makefiles work with expandtab
autocmd FileType make setlocal noexpandtab

" because I hate q:
map q: <Esc>

" fast commands
map ; :

" because :qa hurts my pinky
map mm <Esc>:qa<Return>

" so I can hack things
autocmd FileType c syntax match cTodo /HACK/
autocmd FileType cc syntax match cTodo /HACK/
autocmd FileType cpp syntax match cTodo /HACK/
autocmd FileType h syntax match cTodo /HACK/

" because GCC extension ({ }) isnt valid c syntax
let c_no_curly_error = 1

" pressing \s begins a search and replace on the cursor's token
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

" default menuing sucks
set wildmenu
set wildmode=list:longest

" Jeff's cscope settings
if has("cscope")
        set csprg=/usr/bin/cscope
        " change this to 1 to search ctags DBs first
        set csto=0
        set cst
        set nocsverb
        " add any database in current directory, plus
        " some other places of interest
        if filereadable("cscope.out")
            cs add cscope.out
        endif
        if filereadable("../cscope.out")
            cs add ../cscope.out ../
        endif
        if filereadable("../../cscope.out")
            cs add ../../cscope.out ../../
        endif
        if filereadable("../../../cscope.out")
            cs add ../../../cscope.out ../../..
        endif
        if filereadable("build/cscope.out")
            cs add build/cscope.out build/
        endif
        if filereadable("../build/cscope.out")
            cs add ../build/cscope.out ../build/
        endif
        if filereadable("../../build/cscope.out")
            cs add ../../build/cscope.out ../../build/
        endif
        if $CSCOPE_DB != ""
            cs add $CSCOPE_DB
        endif
        set csverb

        " Using 'CTRL-\' then a search type makes the vim window
        " "shell-out", with search results displayed on the bottom

        " my variant's to jeff's cscope shortcuts. I like
        " leader + letter commands, and these are the most common.
        nmap <Leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <Leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <Leader>f :cs find s <C-R>=expand("<cword>")<CR><CR>

        nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

        " Using 'CTRL-spacebar' then a search type makes the vim window
        " split horizontally, with search result displayed in
        " the new window.

        nmap <C-[>s :scs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-[>g :scs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-[>c :scs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-[>t :scs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-[>e :scs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-[>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-[>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-[>d :scs find d <C-R>=expand("<cword>")<CR><CR>

        " Hitting CTRL-space *twice* before the search type does a vertical
        " split instead of a horizontal one

        nmap <C-[><C-[>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-[><C-[>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-[><C-[>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-[><C-[>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-[><C-[>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-[><C-[>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-[><C-[>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>
endif

" Show in a new window the Subversion blame annotation for the current file. 
function s:svnBlame() 
    let line = line(".") 
    setlocal nowrap 
    " if svn st gives a warning, assume git, else svn.
    let $r = system("svn st")
    if $r =~ "warning"
        aboveleft 40vnew 
        setlocal nomodified buftype=nofile nowrap winwidth=2 
        %!git blame -s -c -w "#"
    else
        aboveleft 23vnew 
        setlocal nomodified buftype=nofile nowrap winwidth=2 
        %!svn blame -x-w "#"
    endif
    exec "normal " . line . "G" 
    setlocal scrollbind 
    wincmd p 
    setlocal scrollbind 
    syncbind 
endfunction 
map gb :call <SID>svnBlame()<CR> 
command Blame call s:svnBlame() 

" use scons when working with MongoDB
if getcwd() =~ "src/mongo/db"
    setlocal makeprg=scons
endif
