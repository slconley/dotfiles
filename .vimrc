set autoindent expandtab hlsearch ignorecase incsearch modeline ruler smartcase showmatch bg=dark modelines=20 shiftwidth=2 tabstop=2
filetype plugin indent on
syntax enable
nmap . .`[

if has("autocmd")
  autocmd BufEnter    * if &filetype == "" | setlocal ft=yaml | endif
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  autocmd FileType make   setlocal noexpandtab shiftwidth=8 softtabstop=0
  autocmd FileType python setlocal expandtab smarttab shiftwidth=4 softtabstop=4 tabstop=2 textwidth=80
endif

if version >= 900
  source ~/.vim/vim90/vimrc
elseif version >= 800
  source ~/.vim/vim80/vimrc
elseif version >= 700
  source ~/.vim/vim70/vimrc
endif

set background=dark

