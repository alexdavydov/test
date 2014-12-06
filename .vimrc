set nocompatible

execute pathogen#infect()

set hlsearch
set incsearch

set backspace=indent,eol,start

syntax on
filetype plugin indent on

set autoindent
set smarttab
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab

set number

autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite

highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/
