" Never hit escape again!
imap jk <Esc>

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
set smarttab      " insert tabs on the start of a line according to shiftwidth, not tabstop
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
set colorcolumn=80 " Line length of 80

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

" Map : to ;
nmap ; :

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
let g:syntastic_python_checkers=[]

" adserver style guide
autocmd FileType c,cpp,make,automake setlocal cinoptions=+4,(4:0 cindent noexpandtab shiftwidth=8 tabstop=8 softtabstop=8
