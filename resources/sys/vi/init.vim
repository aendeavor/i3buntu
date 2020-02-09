" Language and Encoding
set spell spelllang=en_us
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

" Text alignemnt metrics
set ignorecase
set conceallevel=1
set expandtab
set autoindent
set softtabstop=4
set tabstop=4
set shiftwidth=2
set number

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

Plug 'rust-lang/rust.vim'		" RUST language extensions
Plug 'tpope/vim-markdown'		" Markdown language extension
Plug 'vim-syntastic/syntastic'	" Syntax check

" Autocompletion
Plug 'Valloric/YouCompleteMe'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Themes
Plug 'mhartington/oceanic-next'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ryanoasis/vim-devicons'
call plug#end()

" Autocompletion & syntax metrics
let g:deoplete#enable_at_startup = 1
let g:syntastic_check_on_open = 1

" NerdTree configuration
map <C-E> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=0
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.pyc$']
let g:ycm_autoclose_preview_window_after_completion=1
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Mouse settings
set mouse=a                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing

" Theming
set background=dark
set termguicolors
syntax enable
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
colorscheme OceanicNext
let g:lightline = { 'colorscheme': 'wombat' }
