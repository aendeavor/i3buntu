" 
" ██╗███╗   ██╗██╗████████╗██╗   ██╗██╗███╗   ███╗
" ██║████╗  ██║██║╚══██╔══╝██║   ██║██║████╗ ████║
" ██║██╔██╗ ██║██║   ██║   ██║   ██║██║██╔████╔██║
" ██║██║╚██╗██║██║   ██║   ╚██╗ ██╔╝██║██║╚██╔╝██║
" ██║██║ ╚████║██║   ██║██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
" ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
"
" ! INIT.VIM - CONFIGURATION FILE FOR NEOVIM
" ! ~/.config/nvim/init.vim
"
" version   0.4.4
" author    aendeavor@Georg Lauterbach

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Language and Encoding
" set spell spelllang=en_us
set undofile
set encoding=utf-8

" Copy & Waste
if has('clipboard')
  if has('unnamedplus') " use + register for copy-paste
    set clipboard=unnamed,unnamedplus
  else                  " macOS/Windows, * for copy-paste
    set clipboard=unnamed
  endif
endif

" Text alignment metrics
set ignorecase
set conceallevel=1
set expandtab
set autoindent
set softtabstop=4
set tabstop=4
set shiftwidth=2
set number
set scrolloff=25

" Line numbering
:set number relativenumber
:set nu rnu

" Miscellaneous
set history=1000
autocmd BufEnter * lcd %:p:h
filetype plugin indent on
set undodir=~/.config/nvim/undodir

" Visual shifting
vnoremap < <gv
vnoremap > >gv

" Allow using the repeat operator with a visual selection
vnoremap . :normal .<CR>

" Plugins
call plug#begin()
Plug 'scrooloose/nerdtree' 		" File explorer
Plug 'itchyny/lightline.vim' 	" Status line
Plug 'ctrlpvim/ctrlp.vim'		" Full path fuzzy file-, buffer-, ... finder
Plug 'Raimondi/delimitMate'		" Automatic closing of parenthesis, etc.
Plug 'mhinz/vim-startify'		" Fancy start screen

Plug 'tpope/vim-markdown'		" Markdown language extension
Plug 'vim-syntastic/syntastic'	" Syntax check

Plug 'majutsushi/tagbar'        " Tagbar creates an outline
Plug 'luochen1990/rainbow'      " Rainbow brackets

Plug 'Valloric/YouCompleteMe'   " Autocompletion

" Themes
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'ryanoasis/vim-devicons'
call plug#end()

" Autocompletion & syntax metrics
let g:syntastic_check_on_open = 1
let g:ycm_autoclose_preview_window_after_completion=1
let g:rainbow_active = 1

" YouCompleteMe
" compile YCM with 'python3 install.py --rust-completer --clang-completer --clang-tidy"
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = "${HOME}/.config/nvim/plugged/YouCompleteMe/.ycm_extra_conf.py"

" Autoformatting
augroup autoformat_settings
  autocmd FileType python AutoFormatBuffer yapf
augroup END

" NerdTree configuration
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.pyc$']
autocmd VimEnter * wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Mouse settings
set mouse=a                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing

" Theming
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark
syntax enable
colorscheme onehalfdark

let g:lightline = {
\   'colorscheme': 'onehalfdark',
\   'active': {
\     'left':[ [ 'mode', 'paste' ],
\              [ 'gitbranch', 'readonly', 'filename', 'modified' ]
\     ]
\   },
\   'component': {
\     'lineinfo': '%3l:%-2v',
\   },
\   'component_function': {
\     'gitbranch': 'fugitive#head',
\   }
\ }

let g:lightline.separator = {
\   'left': '', 'right': ''
\}

let g:lightline.subseparator = {
\   'left': '', 'right': '' 
\}

" Keymappings for plugins
nmap <F8> :TagbarToggle<CR>
nmap <F7> :NERDTreeToggle<CR>

" Automaticall Open these pluins
" autocmd VimEnter * Tagbar

" README
" The following needs to be installed for TagBar to work: https://github.com/universal-ctags/ctags/blob/master/docs/autotools.rst
