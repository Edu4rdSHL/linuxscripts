" Plugins will be downloaded under the specified directory.
call plug#begin('~/.local/share/nvim/plugged')

" Declare the list of plugins.
" Plug 'morhetz/gruvbox'
Plug 'drewtempelmeyer/palenight.vim'
" Plug 'Badacadabra/vim-archery'
Plug 'Yggdroot/indentLine'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Syntax highlight
Plug 'zchee/deoplete-jedi'
Plug 'rust-lang/rust.vim'
Plug 'mattn/webapi-vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'sheerun/vim-polyglot'

" Neomaker
Plug 'neomake/neomake'

" Neovim airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Auto pair
Plug 'jiangmiao/auto-pairs'

" Completion for Rust
Plug 'sebastianmarkow/deoplete-rust'

"List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Use mustache
let g:mustache_abbreviations = 1

" Use deoplete and set deoplete options
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('check_stderr', v:false)


" Rust config
let g:rustfmt_autosave = 1
let g:rust_clip_command = 'xclip -selection clipboard'

" Enable autocompletion for Rust
let g:deoplete#sources#rust#racer_binary='/home/sechacklabs/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path='/home/sechacklabs/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'
let g:deoplete#sources#rust#disable_keymap=1
let g:deoplete#sources#rust#documentation_max_height=20

" Syntax and programming things
syntax on
set guifont=Monospace\ Bold\ 12
set background=dark
colors palenight
set inccommand=nosplit
" let g:neomake_open_list = 2
let g:neomake_warning_sign = {
  \ 'text': 'W',
  \ 'texthl': 'WarningMsg',
  \ }
let g:neomake_error_sign = {
  \ 'text': 'E',
  \ 'texthl': 'ErrorMsg',
  \ }

" Set clipboard
set clipboard+=unnamedplus

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Lint as you type
if has("autocmd")
  au InsertLeave,TextChanged * silent! update | Neomake
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

set showmatch           " Show matching brackets.
set number              " Show the line numbers on the left side.
set formatoptions+=o    " Continue comment marker in new lines.
set expandtab           " Insert spaces when TAB is pressed.
set tabstop=2           " Render TABs using this many spaces.
set shiftwidth=2        " Indentation amount for < and > commands.
set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)

" More natural splits
set splitbelow          " Horizontal split below current
set splitright          " Vertical split to right of current.
if !&scrolloff
    set scrolloff=3       " Show next 3 lines while scrolling.
endif

if !&sidescrolloff
    set sidescrolloff=5   " Show next 5 columns while side-scrolling.
endif
set nostartofline       " Do not jump to first character with page commands.

" Tell Vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
set list                " Show problematic characters.

" Also highlight all tabs and trailing whitespace characters.
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$\|\t/

" Sample command W to save a file in neovim without root permission with sudo
" command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
