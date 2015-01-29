execute pathogen#infect()
Helptags

syntax on

set number
set noexpandtab
set tabstop=8
set softtabstop=8
set shiftwidth=8
set backspace=2
set pastetoggle=<F2>
set smartindent
set incsearch
set ignorecase
set smartcase
set autoindent
set hlsearch
filetype indent on
filetype plugin on
colorscheme desert
cmap w!! w !sudo tee >/dev/null %

" indentation
set cinoptions+=(0

" ruby stuff
autocmd FileType ruby set shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType html set shiftwidth=2 tabstop=2 softtabstop=2
autocmd BufNew,BufEnter *.erb set shiftwidth=2 tabstop=2 softtabstop=2

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

" it's an addiction now
imap jj <Esc>

" bread and butter
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

" building
map MM <Esc>:make -C dbg -j12<Return>

" so I can hack things
autocmd FileType c syntax match cTodo /HACK/
autocmd FileType cc syntax match cTodo /HACK/
autocmd FileType cpp syntax match cTodo /HACK/
autocmd FileType h syntax match cTodo /HACK/

" begins a search and replace on the token under the cursor
nnoremap <Leader>S :%s/\<<C-r><C-w>\>/

" default menuing sucks
set wildmenu
set wildmode=list:longest

" fugitive mapping for blame
map <Leader>b :Gblame<Return>

" ag mappings
map <Leader>F :Ag <C-r><C-w><Return>
map <Leader>G :Ag 

" so vim stops complaining when opening a file that another vim has opened.
" I know vim, just go read only. Obviously.
func CheckSwap()
  swapname
  if v:statusmsg =~ '\.sw[^p]$'
    set ro
  endif
endfunc
if &swf
  set shm+=A
  au BufReadPre * call CheckSwap()
endi

" so a diff between two files does not force a 'press a key to continue prompt'
if &diff
  set cmdheight=2
endi

" ctrpl ignore
let g:ctrlp_custom_ignore = 'opt\|dbg\|build\|cmake_build\|cmake_dbg\|cmake_opt'

" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim... 
if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " add any cscope database in current directory
    if filereadable("cscope.out")
	set nocscopeverbose
        cs add cscope.out
	set cscopeverbose
    " else add the database pointed to by environment variable 
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    map <Leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>      
    map <Leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>      
    map <Leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>      
    map <Leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>      
    map <Leader>e :cs find e <C-R>=expand("<cword>")<CR><CR>      
    map <Leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>      
    map <Leader>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    map <Leader>d :cs find d <C-R>=expand("<cword>")<CR><CR>      
endif

" From vim.wikia.com
"
" In the [below] mapping, I use 'find' to collect the C/C++ source code files
" and (re)create the cscope database; then 'kill -1' to kill all cscope
" database connections and finally, the newly created 'cscope.out' database is
" added by 'cs add cscope.out'.
"
" There are two limitations in this key mapping:
"
" the current directory should be the root path of the project
" I don't know how to get the current cscope data connection number, so that I
" use 'kill -1' to kill 'all' cscope database connections, since actually I
" always only create one connections in one Vim instance. It is not practical
" if you are using multiple data connections in one Vim instance.
func ResetCScopeDB()
    :!find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files &&
        \cscope -q -k -b -i cscope.files -f cscope.out && 
	\echo Built cscope database from $(cat cscope.files | wc -l) files
    :cs kill -1
    :cs add cscope.out
endfunc
map HH :call ResetCScopeDB()<Return>

" for macvim
if has("gui_macvim")
    set guifont=Anonymous\ Pro:h20
    map MM
endif
