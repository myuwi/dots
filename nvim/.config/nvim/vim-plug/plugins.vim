call plug#begin('~/.config/nvim/autoload/plugged')

    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    
    " File Explorer
    Plug 'scrooloose/NERDTree'
    
    " Auto pairs for '(' '[' '{'
    " Plug 'jiangmiao/auto-pairs'
    
    " Pear Tree
    Plug 'tmsvg/pear-tree'

    " Surround with quotes
    Plug 'tpope/vim-surround'
    
    " Themes
    Plug 'joshdick/onedark.vim'
    Plug 'arcticicestudio/nord-vim'
    Plug 'dylanaraps/wal.vim'

    " Stable version of coc
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    Plug 'honza/vim-snippets'
    
    " Status Line
    Plug 'vim-airline/vim-airline'

    " Colorizer
    Plug 'lilydjwg/colorizer'

    " Gitgutter
    Plug 'airblade/vim-gitgutter'

call plug#end()
