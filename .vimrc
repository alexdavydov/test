set nocompatible

set hlsearch
set incsearch

set backspace=indent,eol,start

syntax on

set autoindent
set smarttab
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

set number

autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite
