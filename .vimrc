syntax on
set nocompatible
filetype plugin indent on
syntax reset
colorscheme ir_black
let g:fuzzy_roots = ["."]
let g:fuzzy_ignore = '.DS_Store;.o;.bak;*/log/*;.swp;*/doc/*;doc/*;public/resources/*;'
let g:fuzzy_matching_limit = 50
let mapleader = ","
let loaded_matchparen=1
set softtabstop=2
set browsedir=current
set number
set hlsearch
set grepprg=ack
set grepformat=%f:%l:%m
set shiftwidth=2
set foldmethod=syntax
set tabstop=2
set expandtab
map <Leader>t :FuzzyFinderTextMate<CR>
map <Leader>b :FuzzyFinderBuffer<CR>
map <Leader>d :FuzzyFinderDir<CR>
set ai
set vb t_vb=
set si
set cursorline
set showcmd
set ruler
set tags+=~/.ctags-rails
cmap w!! %!sudo tee > /dev/null %
