" Language and Encoding
set spell spelllang=en_us
set undofile
set encoding=utf-8

if has('clipboard')
  if has('unnamedplus') " use + register for copy-paste
    set clipboard=unnamed,unnamedplus
  else                  " macOS/Windows, * for copy-paste
    set clipboard=unnamed
  endif
endif

set ignorecase
set number
set conceallevel=1
set expandtab
set autoindent
set softtabstop=4
set shiftwidth=2
set tabstop=4

set history=1000

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" let g:gruvbox_italic=1
colorscheme NeoSolarized

autocmd BufEnter * lcd %:p:h

filetype plugin indent on

set undodir=~/.config/nvim/undodir

" plugins
call plug#begin()

Plug 'vim-scripts/Vimball'
Plug 'godlygeek/tabular'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/goyo.vim'
Plug 'rust-lang/rust.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'groenewege/vim-less'
Plug 'tpope/vim-markdown'
Plug 'Valloric/YouCompleteMe'
Plug 'michaeljsmith/vim-indent-object'
Plug 'vim-syntastic/syntastic'
Plug 'Shougo/neocomplcache.vim'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'Raimondi/delimitMate'
Plug 'tmhedberg/SimpylFold'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'mhinz/vim-startify'
Plug 'Quramy/tsuquyomi'
Plug 'Shougo/vimproc.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Themes
Plug 'mhartington/oceanic-next'
Plug 'drewtempelmeyer/palenight.vim'

call plug#end()

let g:syntastic_check_on_open=1

map <C-E> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=0
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.pyc$']
let g:ycm_autoclose_preview_window_after_completion=1
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

set foldmethod=indent
set foldlevel=99

set mouse=a                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing

" Theming
set background=dark

