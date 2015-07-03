" Use Vim settings, rather then Vi settings. This setting must be as early as
" possible, as it has side effects.
set nocompatible


" --------------- load external files ---------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

Plug 'junegunn/seoul256.vim'
Plug 'kien/ctrlp.vim'
Plug 'kchmck/vim-coffee-script'

Plug 'tpope/vim-fugitive'

Plug 'bling/vim-airline'
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'bubblegum'
let g:airline_powerline_fonts = 1   " requires fonts installed from https://github.com/powerline/fonts

Plug 'tpope/vim-rails'

Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

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
let g:seoul256_background = 235  " Range:   233 (darkest) ~ 239 (lightest)
colo seoul256


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

" show all buffers in tabs, or close all tabs
let notabs = 0
nnoremap <silent> <F8> :let notabs=!notabs<Bar>:if notabs<Bar>:tabo<Bar>:else<Bar>:tab ball<Bar>:tabn<Bar>:endif<CR>

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

let mapleader="\<Space>"
nmap <Leader>t :CtrlP<CR>


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


" --------------- keyboard shortcuts ---------------
noremap <C-d> :sh<cr>    " ctrl-d to switch between vim and a new shell


" --------------- application settings ---------------
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set noerrorbells         " don't beep
set nobackup             " don't create a backup file
set noswapfile           " don't create a swap file


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



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MapCR()
  nnoremap <cr> :call RunTestFile()<cr>
endfunction
call MapCR()
nnoremap <leader>T :call RunNearestTest()<cr>
nnoremap <leader>a :call RunTests('')<cr>
nnoremap <leader>c :w\|:!script/features<cr>
nnoremap <leader>w :w\|:!script/features --profile wip<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.py\)$') != -1
    if in_test_file
        call SetTestFile(command_suffix)
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

function! SetTestFile(command_suffix)
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@% . a:command_suffix
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    if expand("%") != ""
      :w
    end
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        " First choice: project-specific test script
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        " Fall back to the .test-commands pipe if available, assuming someone
        " is reading the other side and running the commands
        elseif filewritable(".test-commands")
          let cmd = 'rspec --color --format progress --require "~/lib/vim_rspec_formatter" --format VimFormatter --out tmp/quickfix'
          exec ":!echo " . cmd . " " . a:filename . " > .test-commands"

          " Write an empty string to block until the command completes
          sleep 100m " milliseconds
          :!echo > .test-commands
          redraw!
        " Fall back to a blocking test run with Bundler
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        " If we see python-looking tests, assume they should be run with Nose
        elseif strlen(glob("test/**/*.py") . glob("tests/**/*.py"))
            exec "!nosetests " . a:filename
        " Fall back to a normal blocking test run
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction
