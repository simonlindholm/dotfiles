" Jump to the last position when reopening a file
" au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Gitgutter options
"set updatetime=750
let g:gitgutter_diff_args = '-w'
let g:gitgutter_eager = 0
let g:gitgutter_realtime = 0

" Go support
let go_highlight_trailing_whitespace_error=0

" Don't indent "public:", "case X:", or return type declarations
set cinoptions=g0:0t0

let b:surround_indent = 1
silent! call pathogen#infect()

" Load indentation rules and plugins according to filetype.
filetype plugin indent on

" Probably the most controversial part: remap jk, kj to escape. Requires a
" short timeoutlen to avoid jkj resulting in <esc>j, among other problems.
inoremap jk <Esc>
inoremap kj <Esc>
set timeoutlen=200

" Optionally:
" set nu expandtab

" Joining comments
set formatoptions+=j
set nojoinspaces

" Don't continue comments over several lines.
au BufRead,BufNewFile * setlocal formatoptions-=o | setlocal formatoptions-=r

function! s:ValaSettings()
	setfiletype java
	setlocal efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
	setlocal syntax=vala
endfunction
au BufRead,BufNewFile *.vala call s:ValaSettings()
au BufRead,BufNewFile *.vapi call s:ValaSettings()
au BufRead,BufNewFile *.as set syntax=javascript cindent
au BufRead,BufNewFile *.jsm set syntax=javascript cindent
au BufRead,BufNewFile *.mxml set filetype=xml
au BufRead,BufNewFile *.md set filetype=markdown
au BufRead,BufNewFile *.scala setlocal et sw=2 ts=2 sts=2
au BufRead,BufNewFile *.tex setlocal et sw=2 ts=2 sts=2
au BufRead,BufNewFile *.hs setlocal et

" Local overrides
au BufRead,BufNewFile */mozilla-central/* setlocal et sw=2 ts=2 sts=2
" (etc.)

" Highlight en spaces, em spaces, non-breaking spaces and soft hyphens with
" a strong red color.
au BufNewFile,BufReadPost * match ExtraWhitespace /\(\%u2002\|\%u2003\|\%xa0\|\%xad\)/
highlight ExtraWhitespace ctermbg=red guibg=red
highlight clear SignColumn

" Dark background by default
set bg=dark " light
if has("gui_running")
	set bg=light
endif

set showcmd         " Show (partial) command in status line.
set ignorecase      " Do case insensitive matching
set smartcase       " Do smart case matching
set wildignorecase  " Ignore case even for file names
set incsearch       " Incremental search
set autowrite       " Automatically save before commands like :next and :make
set autoread        " Reload externally changed files

set modeline

" Use the *correct* charset.
set encoding=utf-8

" Set search highlighting
set hlsearch

" <Ctrl-l> also removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>
imap <c-l> <c-o><c-l>

" Provide some space above/below the current line
set scrolloff=2
set sidescrolloff=5

" Indentation with 4-space tabs per default
set smarttab
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Round indentation to a multiple of 4 with >> and <<
set shiftround

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
set wildignore=.svn,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pdf,*.bak,*.beam,*.hi

" Make it possible to save even with forgotten sudo
cabbrev w!! w !sudo tee % >/dev/null

" Nicer highlighting color for matching parens
highlight MatchParen ctermbg=0
"highlight MatchParen ctermbg=7 " light background

" Automatically change to the containing directory when opening a file
set autochdir
if expand("%") != "" | cd %:h | endif " workaround for https://github.com/vim/vim/issues/704, fixed in 7.4.1716

" Swapfiles/backups are more annoying than helpful
set nobackup
set noswapfile

nnoremap j gj
nnoremap k gk

" <F1> is probably mistyped <Esc>, and is also never used.
nnoremap <F1> <Esc>
inoremap <F1> <Esc>

nnoremap <F2> :Gstatus<cr>

nnoremap <silent> <F3> :make %<<cr>:cw<cr>

" Map ; to :, because : is used more
noremap ; :

function EnglishLayout()
	call system('gsettings set org.gnome.desktop.input-sources current 0')
endfunction

" Swedish, sometimes convenient
" Å, Ä and å are generally mistakes and continued by other English-
" language commands; thus, they swap keyboard layout back to English.
noremap ö :
noremap Ö :
noremap ä '
noremap <silent> Ä :call EnglishLayout()<CR>"
noremap <silent> Å :call EnglishLayout()<CR>{
noremap <silent> å :call EnglishLayout()<CR>[
noremap ¤ $
noremap ½ ~
noremap § `
noremap - /
noremap! ¤ $
noremap! ½ ~
noremap! § `

" For using Swedish keyboard layout as if it were English:
" :set langmap=å[,ä',ö:,Å{,Ä\",Ö:,¨],^},'\\\\,*\|,\\;<,:>,-/,_?,½~
"               ,\"@,¤$,&^,/&,(*,)(,=),?_,`+,+-,´=,§`
" Does unfortunately not work very well with key mapping, and Swedish delayed
" keys are still there for, for example, } and ~.

" Lower the timeout for prefix keymaps (jkj should be j<esc>, and try to
" avoid lag for the cursor).
au InsertEnter * set timeoutlen=100
au InsertLeave * set timeoutlen=1000

" Don't wait forever to cancel selections.
set ttimeoutlen=50

" Ctrl-j/k inserts blank line below/above.
nnoremap <silent><C-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

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

" paste from yank register
"noremap yp "0p
"noremap yP "0P

" let mapleader = ","

nnoremap <leader>q :q<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

nnoremap <leader>d :set bg=dark<cr>
nnoremap <leader>f :set bg=light<cr>

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-k> <c-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<cr>

" & highlights the word under the cursor
noremap <silent> & :let @/ = "\\<<c-r><c-w>\\>"<cr>:set hlsearch<cr>

set showbreak=↳\ " (a single space)

" Display incomplete lines instead of a bunch of @
set display=lastline

" No vim intro
set shm+=I

" Ignore whitespace with vimdiff
set diffopt=filler,iwhite

" List the number of substitutions for :s etc. when it's > 1
set report=1

cabbrev te tabe

" no-brainer limit increases
set tabpagemax=50
set undolevels=10000

" Smoother redrawing with no downside, apparently.
set ttyfast

set nrformats-=octal

set history=1000
set viminfo+=:1000
