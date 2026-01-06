if version >= 900
  source ~/.vim/vim90/vimrc
elseif version >= 800
  source ~/.vim/vim80/vimrc
elseif version >= 700
  source ~/.vim/vim70/vimrc
endif

filetype plugin indent on
syntax enable

" keep cursor in current position after repeat (".") command
nmap . .`[
"
" disable highlight via <esc><esc>
nnoremap <silent> <esc><esc> :nohlsearch

set autoindent expandtab hlsearch ignorecase incsearch modeline ruler smartcase showmatch bg=dark modelines=20 shiftwidth=2 tabstop=2

if has("autocmd")
  autocmd BufEnter    * if &filetype == "" | setlocal ft=yaml | endif
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  autocmd FileType make   setlocal noexpandtab shiftwidth=8 softtabstop=0
  autocmd FileType python setlocal expandtab smarttab shiftwidth=4 softtabstop=4 tabstop=2 textwidth=80
endif


