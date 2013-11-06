" Jump to the last position when reopening a file
"if has("autocmd")
"	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Clang auto-completion
set completeopt=menu
let g:clang_use_library=1
let g:clang_library_path='/usr/lib'
let g:clang_auto_select=1
let g:clang_hl_errors=1
let g:clang_complete_auto=0
"let g:clang_complete_copen=1
let g:clang_periodic_quickfix=0
autocmd Filetype c,objc,cpp autocmd BufWritePre <buffer> :call g:ClangUpdateQuickFix()

let b:surround_indent = 1
call pathogen#infect()

if has("autocmd")
	" Load indentation rules and plugins according to filetype.
	filetype plugin indent on

	" Don't continue comments over several lines.
	au BufNewFile,BufRead * setlocal formatoptions-=o | setlocal formatoptions-=r

	" Vala support
	function! s:ValaSettings()
		setfiletype java
		setlocal efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
		setlocal syntax=vala
	endfunction
	au BufRead,BufNewFile *.vala call s:ValaSettings()
	au BufRead,BufNewFile *.vapi call s:ValaSettings()

	" ActionScript, Flex
	au BufRead,BufNewFile *.as set syntax=javascript | set cindent
	au BufRead,BufNewFile *.mxml set filetype=xml

	" Save things on lost focus
	au FocusLost silent! :wa

    au BufRead,BufNewFile /home/lars/simon/programming/firebug/* setlocal expandtab
endif

highlight clear SignColumn


set showcmd         " Show (partial) command in status line.
set ignorecase      " Do case insensitive matching
set smartcase       " Do smart case matching
set wildignorecase  " Ignore case even for file names
set incsearch       " Incremental search
set autowrite       " Automatically save before commands like :next and :make
"set hidden         " Keep hidden buffers alive
"set mouse=a        " Enable mouse usage (all modes)

" Use the *correct* charset.
set encoding=utf-8

" Set search highlighting
set hlsearch

" <Ctrl-l> also removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>
imap <c-l> <c-o><c-l>

" Provide some space above/below the current line
set scrolloff=2

" Indentation with 4-space tabs per default
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Remove this - it is very annoying at times when the indentation level
"  gets set to some ridiculous number of spaces.
" " Automatically find indentation style
" let g:detectindent_preferred_indent = 4
" let g:detectindent_max_lines_to_analyse = 256
" autocmd BufReadPost * :DetectIndent

" Make tab completion behave kindof like bash
set wildmenu
set wildmode=longest:full

" Ignore some binary things in completion
set wildignore=.svn,CVS,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pdf,*.bak,*.beam

" Make it possible to save even with forgotten sudo
cmap w!! w !sudo tee % >/dev/null

" Nicer highlighting color for matching parens
highlight MatchParen ctermbg=0
"highlight MatchParen ctermbg=7 " light background

" Automatically change to the containing directory when opening a file
set autochdir

" Swapfiles/backups are more annoying than helpful
set nobackup
set noswapfile

" Remap jk, kj to escape, since they are not used anyway
inoremap jk <Esc>
inoremap kj <Esc>

nnoremap j gj
nnoremap k gk

" <F1> is probably mistyped <Esc>, and is also never used.
nnoremap <F1> <Esc>
inoremap <F1> <Esc>

nnoremap <F2> :Gstatus<cr>

" Map ; to :, because : is used more
noremap ; :

" Swedish, sometimes convenient
noremap ö :
noremap ¤ $
noremap ½ ~
noremap § `
noremap - /

" Let ;; be the new ;, should I ever need it
noremap ;; ;

" Lower the timeout for prefix keymaps (jkj should be j<esc>, and try to
" avoid lag for the cursor).
set timeoutlen=300

" Ctrl-j/k inserts blank line below/above.
nnoremap <silent><C-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

" For using Swedish keyboard layout as if it were English:
" :set langmap=å[,ä',ö:,Å{,Ä\",Ö:,¨],^},'\\\\,*\|,\\;<,:>,-/,_?,½~
"               ,\"@,¤$,&^,/&,(*,)(,=),?_,`+,+-,´=,§`
" Does unfortunately not work very well with key mapping, and Swedish delayed
" keys are still there for, for example, } and ~.

" Make replaying simples macros recorded with qq easier
nnoremap Q @q
nnoremap <c-q> :let @q = @q . '@q'<cr>@q

nnoremap <C-I> gt
nnoremap [Z gT

" ... and Ctrl-P for Ctrl-O, because Tab is the same as Ctrl-I...
nnoremap <c-p> <c-i>

" I make this mistake a lot
noremap <S-k> k

" paste lines from unnamed register and fix indentation
noremap <leader>p pV`]=
noremap <leader>P PV`]=

" XML indentation - I might use this some time.
vmap ,px !xmllint --format -<CR>
nmap ,px !!xmllint --format -<CR>

" Go support
let go_highlight_trailing_whitespace_error=0

" let mapleader = ","

nnoremap <leader>w :w<cr>
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

noremap <c-c> "+y

cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" & highlights the word under the cursor
noremap & :let @/ = "<c-r><c-w>"<cr>:set hlsearch<cr><c-l>

set showbreak=↳\ " (a single space)

" Display incomplete lines instead of a bunch of @
set display=lastline

" No vim intro
set shm+=I

" Ignore whitespace with vimdiff
set diffopt=filler,iwhite

" Don't indent "public:", "case X:", or return type declarations
set cinoptions=g0:0t0

" List the number of substitutions for :s etc. when it's > 1
set report=1
