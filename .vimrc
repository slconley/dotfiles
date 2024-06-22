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

" generally agreeable picks for me (from v9)
colorscheme desert
colorscheme elflord
colorscheme evening
colorscheme habamax
colorscheme koehler
colorscheme pablo
colorscheme ron
colorscheme slate

" minimalistic but still nice
colorscheme quiet

" front-runners
colorscheme retrobox

" current favorite(s)
colorscheme torte
if version >= 900 | colorscheme sorbet | endif

