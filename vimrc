set nocompatible              " be iMproved, required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

call plug#begin()
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
call plug#end()

" Never hit escape again!
imap jk <Esc>

" Ctrl+n to open Nerdtree
map <C-n> :NERDTreeToggle<CR>
" Open Nerdtree if no files are specified, close vim if Nerdtree is last window open
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" remove any trailing whitespace that is in the file
" autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" in many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" " We can use different key mappings for easy navigation between splits to save a keystroke.
" " So instead of ctrl-w then j, it’s just ctrl-j:
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Resizing vim splits more easily
nnoremap <silent> + :exe "resize +2"<CR>
nnoremap <silent> - :exe "resize -2"<CR>
nnoremap <silent> > :exe "vertical resize +2"<CR>
nnoremap <silent> < :exe "vertical resize -2"<CR>

" Open new split panes to right and bottom, which feels more natural than Vim’s default:
set splitbelow
set splitright

set cursorline
set t_Co=256	  " Use 256 colors!
set wildmenu      " tab completion
set wildmode=list:longest,full " tab completion
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase, case-sensitive otherwise
" set smarttab      " insert tabs on the start of a line according to shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
set history=100   " keep 50 lines of command line history
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set nowrap        " turn off line wrapping
set number	  " line numbers
set noswapfile
set colorcolumn=100 " Line length of 80

" pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on

syntax enable
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=0
colorscheme solarized

" Clear highlighting on escape in normal mode
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[

" Search for visually selected text
vnoremap // y/<C-R>"<CR>

" substitute text under cursor
nnoremap <Leader>s :.,$s/\<<C-r><C-w>\>/

" Map : to ;
nmap ; :

" zz to ctrl-c
nnoremap <C-c> zz

" fuzzy file search
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_map='<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'
" airline
set laststatus=2
let g:airline_enable_branch=1

" syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
let g:syntastic_enable_signs= 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" Got them pretty symbols
let g:syntastic_style_error_symbol = '✠'
let g:syntastic_style_warning_symbol = '≈'
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'

" Checkers
" let g:syntastic_python_checkers=['flake8']
" let g:syntastic_python_checkers=[]
" let g:syntastic_go_checkers = ['go', 'golint', 'govet']
let g:syntastic_go_checkers = ['golint', 'govet']

" vim-go
let g:go_fmt_command = 'gofmt'
let g:go_fmt_command = 'goimports'
let g:go_fmt_autosave = 1
let g:go_def_mode = 'godef'
nnoremap <leader>d :GoDef<CR>

" Ag
nnoremap <Leader>f :Ag! -f  <C-r><C-w><Return>
nnoremap <Leader>g :Ag! -f

" adserver style guide
autocmd FileType c,cpp,make,automake setlocal cinoptions=+4,(4:0 cindent noexpandtab shiftwidth=8 tabstop=8 softtabstop=8
