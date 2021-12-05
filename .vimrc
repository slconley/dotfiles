set expandtab ignorecase incsearch paste ruler smartcase showmatch shiftwidth=2 tabstop=2 modeline modelines=20
set rtp+=/usr/local/opt/fzf
filetype plugin indent on
autocmd FileType make setlocal noexpandtab shiftwidth=8 softtabstop=0
autocmd FileType python setlocal expandtab smarttab shiftwidth=4 softtabstop=4 tabstop=2 textwidth=80
autocmd BufEnter * if &filetype == "" | setlocal ft=yaml | endif


"colorscheme torte
"colorscheme murphy
colorscheme elflord
"colorscheme koehler
"colorscheme darkblue

if &t_Co > 2 || has("gui_running")
  syntax enable
  set hlsearch
endif

if has("autocmd")
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

nmap . .`[

