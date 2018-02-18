" Contents
"
" Plugins (#p)
" - Colorschemes   (#p.0) Statusline     (#p.1)
" - Tags           (#p.2)
" - Autocompletion (#p.3)
" - Utilities      (#p.4)
" - Linting        (#p.5)
" - Language       (#p.6)
" Settings (#s)
" Keybinds (#k)

"----------------------------------------"
"                                        "
"               Plugins (#p)             "
"                                        "
"----------------------------------------"

call plug#begin('~/.config/nvim/bundle')

  " Colorschemes (#p.0)

  Plug 'morhetz/gruvbox' "{
    let g:gruvbox_italic=1
    let g:gruvbox_contrast_dark='soft'
  "} 

  " Status Line (#p.1)

  Plug 'airblade/vim-gitgutter' "{
    let g:gitgutter_map_keys=0
  "}

  " Tags (#p.2)

  Plug 'ludovicchabant/vim-gutentags' "{
    let g:gutentags_cache_dir='~/.config/nvim/tags'
  "}
  Plug 'majutsushi/tagbar'
  Plug 'scrooloose/nerdtree' "{
    nnoremap <SPACE>= :NERDTreeToggle<CR>
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  "}

  " Autocompletion (#p.3)

  Plug 'Shougo/neosnippet'
  Plug 'Shougo/neosnippet-snippets'
  Plug 'zchee/deoplete-clang'
  Plug 'artur-shaik/vim-javacomplete2'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "{
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
    let g:deoplete#enable_at_startup = 1 
    let g:deoplete#ignore_sources = {}
    let g:deoplete#ignore_sources._ = ['buffer', 'around']
    let g:deoplete#sources#clang#libclang_path='/usr/local/lib/cquery/lib/clang+llvm-5.0.1-x86_64-linux-gnu-ubuntu-14.04/lib/libclang.so.5'
    let g:deoplete#sources#clang#clang_header='/usr/local/lib/cquery/lib/clang+llvm-5.0.1-x86_64-linux-gnu-ubuntu-14.04/lib/clang'
    let g:deoplete#omni#input_patterns={}
    let g:deoplete#omni#input_patterns.rust='[(\.)(::)]'
    let g:deoplete#omni#input_patterns.ocaml='[^ ,;\t\[()\]]{2,}'
  "}
  "
  Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'} "{
		let g:LanguageClient_serverCommands = {
        \ 'c': ['cquery'],
        \ 'cpp': ['cquery'],
        \ 'python': ['pyls'],
        \ 'rust': ['rls'],
        \ }

    nnoremap <silent> <SPACE>h :call LanguageClient_textDocument_hover()<CR>
    nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
    nnoremap <silent> <SPACE>r :call LanguageClient_textDocument_rename()<CR>
	"}

  " Utilities (#p.4)

  Plug 'airblade/vim-rooter'
  Plug 'tmux-plugins/vim-tmux-focus-events'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim' "{
    " Use ripgrep instead of Ag
    command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)
  "}
  Plug 'raimondi/delimitmate'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'justinmk/vim-sneak'

  " Linting (#p.5)

  " Language-specific (#p.6)

  Plug 'donRaphaco/neotex'  , { 'for': 'tex'  }
  Plug 'rust-lang/rust.vim' , { 'for': 'rust' } "{
    let g:rustfmt_fail_silently=1
  "}
  Plug 'cespare/vim-toml'

  " ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
  let s:opam_share_dir = system("opam config var share")
  let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')
  let s:opam_configuration = {}

  function! OpamConfOcpIndent()
    execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
  endfunction
  let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

  function! OpamConfOcpIndex()
    execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
  endfunction
  let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

  function! OpamConfMerlin()
    let l:dir = s:opam_share_dir . "/merlin/vim"
    execute "set rtp+=" . l:dir
  endfunction
  let s:opam_configuration['merlin'] = function('OpamConfMerlin')

  let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
  let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
  let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
  for tool in s:opam_packages
    " Respect package order (merlin should be after ocp-index)
    if count(s:opam_available_tools, tool) > 0
      call s:opam_configuration[tool]()
    endif
  endfor
  " ## end of OPAM user-setup addition for vim / base ## keep this line
call plug#end()

"----------------------------------------"
"                                        "
"              Settings (#s)             "
"                                        "
"----------------------------------------"

" Terminal true color
execute "set t_8f=\e[38;2;%lu;%lu;%lum"
execute "set t_8b=\e[48;2;%lu;%lu;%lum"
colorscheme gruvbox
hi EndOfBuffer ctermbg=none ctermfg=none guibg=none guifg=none
hi Normal guibg=none ctermbg=none

filetype plugin indent on
filetype plugin on
syntax on
set autoindent
set autoread
set smartindent
set scrolloff=5
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set nonumber
set norelativenumber
set mouse=
set splitright
set backspace=indent,eol,start
set hidden
set noshowmode
set noruler
set laststatus=0
set noshowcmd
set display=lastline
set ttyfast
set lazyredraw
set incsearch
set hlsearch
set sessionoptions-=options
set background=dark
set termguicolors
set completeopt-=preview
set updatetime=250

augroup FourSpaces
  autocmd Filetype java,groovy,c,cpp,makefile setlocal tabstop=4
  autocmd Filetype java,groovy,c,cpp,makefile setlocal softtabstop=4
  autocmd Filetype java,groovy,c,cpp,makefile setlocal shiftwidth=4
  autocmd Filetype makefile setlocal noexpandtab
augroup end

let g:python_host_prog="/home/nwtnni/.pyenv/versions/neovim2/bin/python"
let g:python3_host_prog="/home/nwtnni/.pyenv/versions/neovim3/bin/python3"

" Tags options
set cpoptions+=d
set tags=./.tags

" Backup options
set backupdir=~/.config/nvim/temp
set directory=~/.config/nvim/temp
set undodir=~/.config/nvim/temp
set undofile

" Fold options
set foldenable
set foldlevel=99
set foldnestmax=5
set viewoptions=cursor,folds,slash,unix

"----------------------------------------"
"                                        "
"              Keybinds (#s)             "
"                                        "
"----------------------------------------"

let mapleader = "\<SPACE>"

" Better escaping
inoremap jk <esc>
nnoremap j gj
nnoremap k gk

" Rebind increment/decrement to avoid conflict with tmux
nnoremap <M-a> <C-a>
nnoremap <M-x> <C-x>

" Source .vimrc
nnoremap \ev :vsplit ~/.config/nvim/init.vim<CR>

" Clear search
nnoremap <SPACE>h :nohlsearch<CR>

" Swap 0 and ^
noremap 0 ^
noremap ^ 0
nnoremap <S-L> $
vnoremap <S-L> $
nnoremap <S-H> ^
vnoremap <S-H> ^

" Split line
nnoremap <S-K> 080lBi<CR><ESC>

" Insert space before
nnoremap <SPACE><SPACE> i<SPACE><ESC>

" Write
nnoremap \w :w<CR>
nnoremap \q :wq<CR>

" Yank to system buffer
vnoremap \y "+y
vnoremap \d "+d
nnoremap \p "+p
nnoremap \<S-p> "+P

nnoremap <SPACE>- :TagbarToggle<CR>
nnoremap <SPACE>t :Files<CR>

let s:hidden_all = 1
function! ToggleHiddenAll()
    if s:hidden_all == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
        set nonumber
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
        set number
    endif
endfunction
nnoremap <SPACE>0 :call ToggleHiddenAll()<CR>

fun! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfun
nnoremap <F2> :call TrimWhitespace()<CR>

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
endfunction
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Open fzf in horizontal split
nnoremap <silent> \s :call fzf#run({
\  'down': '40%',
\  'sink': 'botright split' })<CR>

" Open fzf in horizontal split
nnoremap <silent> \v :call fzf#run({
\  'right': winwidth('.') / 2,
\  'sink':  'vertical botright split' })<CR>

" Expand snippets with tab
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" Expands or completes the selected snippet/item in the popup menu
imap <expr><silent><CR> pumvisible() ? deoplete#mappings#close_popup() .
      \ "\<Plug>(neosnippet_jump_or_expand)" : "\<CR>"
smap <silent><CR> <Plug>(neosnippet_jump_or_expand)
