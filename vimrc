execute pathogen#infect()
Helptags

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
set hlsearch
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

" so I can hack things
autocmd FileType c syntax match cTodo /HACK/
autocmd FileType cc syntax match cTodo /HACK/
autocmd FileType cpp syntax match cTodo /HACK/
autocmd FileType h syntax match cTodo /HACK/

" pressing \s begins a search and replace on the cursor's token
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

" default menuing sucks
set wildmenu
set wildmode=list:longest

" fugitive mappings
map <Leader>b :Gblame<Return>
map <Leader>c :Gcommit<Return>
map <Leader>d :Gdiff<Return>

" ag mappings
map <Leader>f :Ag <C-r><C-w><Return>
map <Leader>g :Ag 

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
