set expandtab ignorecase incsearch modeline paste ruler smartcase showmatch modelines=20 shiftwidth=2 tabstop=2
filetype plugin indent on
nmap . .`[

if &t_Co > 2 || has("gui_running")
  syntax enable
  set hlsearch
endif

if has("autocmd")
  autocmd BufEnter    * if &filetype == "" | setlocal ft=yaml | endif
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  autocmd FileType make   setlocal noexpandtab shiftwidth=8 softtabstop=0
  autocmd FileType python setlocal expandtab smarttab shiftwidth=4 softtabstop=4 tabstop=2 textwidth=80
endif

colorscheme torte

if version >= 900 
  source ~/.vim/vim90/vimrc
elseif version >= 800
  source ~/.vim/vim80/vimrc
elseif version >= 700
  source ~/.vim/vim70/vimrc
endif

