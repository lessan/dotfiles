" Use Vim settings, rather then Vi settings. This setting must be as early as
" possible, as it has side effects.
set nocompatible


" --------------- load external files ---------------
call plug#begin('~/.vim/plugged')

"Plug 'junegunn/seoul256.vim'
Plug 'kien/ctrlp.vim'
Plug 'kchmck/vim-coffee-script'

call plug#end()


" --------------- indentation ---------------
set tabstop=2            " tab equals two spaces
set expandtab            " convert tabs to spaces
set autoindent           " always set autoindenting on
set shiftwidth=2         " number of spaces to use for autoindenting
set shiftround           " use multiple of shiftwidth when indenting with '<' and '>'
set copyindent           " copy the previous indentation on autoindenting
set smarttab             " insert tabs on the start of a line according to
                         "    shiftwidth, not tabstop
set pastetoggle=<F2>     " press this key to toggle auto-indent off and on, for pasting


" --------------- formatting ---------------
set title                " change the terminal's title
set number               " always show line numbers
set nowrap               " don't wrap lines
set laststatus=2         " always display the status line
set list listchars=tab:»·,trail:·,nbsp:·  " display extra whitespace


" --------------- color scheme ---------------
set t_Co=256             " set the terminal to 256 colors
colorscheme lucius
LuciusDark
highlight NonText guibg=#060606
highlight Folded  guibg=#0A0A0A guifg=#9090D0


" --------------- navigation ---------------
set showmatch            " set show matching parenthesis
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set cursorline           " highlight the current line

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>


" --------------- search ---------------
set ignorecase           " ignore case when searching
set smartcase            " ignore case if search pattern is all lowercase,
                         "    case-sensitive otherwise
set hlsearch             " highlight search terms
set incsearch            " show search matches as you type

" Clear the search buffer when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()


" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
let g:ctrlp_max_depth = 15
let g:ctrlp_max_files = 100000
let g:ctrlp_working_path_mode = 'w'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/log/*,*/vendor/bundle,*/vendor/bower*,*/node_modules,*/coverage/*


" --------------- application settings ---------------
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set noerrorbells         " don't beep
set nobackup             " don't create a backup file
set noswapfile           " don't create a swap file


filetype plugin indent on
augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" more filetypes
au BufRead,BufNewFile *.eco set filetype=coffee
