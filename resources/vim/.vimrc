" BASICS
set encoding=utf-8
set nocompatible

" TABS & WRAPPING
set wrap
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set noshiftround
set textwidth=120
set autoindent
set backspace=indent,eol,start

" SEARCHING
set ignorecase
set incsearch

" OTHER
set showcmd
set hidden
set wildmenu
set modelines=0
set smartcase
set nostartofline
set ruler
set laststatus=2
set confirm
set visualbell
set noeb vb t_vb=
set mouse=a
set cmdheight=2
set number
set notimeout ttimeout ttimeoutlen=200
set pastetoggle=<F11>
set formatoptions=tcqrn1
set scrolloff=5
set backspace=indent,eol,start
set ttyfast
set showmode
set matchpairs+=<:>
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.

" MAPPINGS
map Y y$
nnoremap <C-L> :nohl<CR><C-L>

" STATUSLINE
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]
set viminfo='100,<9999,s100

" AUTOMATICALLY SAVE AND LOAD FOLDS
autocmd BufWinEnter *.* silent loadview"
