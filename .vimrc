set nocompatible
source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin

call pathogen#incubate()
call pathogen#helptags()


set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

set nocompatible 
set ls=2
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set nowrap
set backspace=indent,eol,start 
set autoindent 
set hlsearch
set incsearch
set number
set showmatch
set ignorecase
"set noignorecase
set title
set cmdheight=2
set ttyfast
" set linebreak " Don't wrap words by default
set textwidth=0 
" set nobackup 
set viminfo='20,\"50 
set history=50 " 
set ruler 
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set wildmenu
"set wildmode=list:longest,full
set foldmethod=indent
set foldlevel=99

if has("gui_running")
	set guifont=Droid\ Sans\ Mono\ 13
	"set guioptions-=m  "remove menu bar
    nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
    inoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
	set guioptions-=T  "remove toolbar
	set guioptions-=r  "remove right-hand scroll bar
	set lines=40
	set columns=132
	set selectmode=mouse,key,cmd
	set mouse=a
else
	"
endif

" Disable arrows to force use of hjkl

"nnoremap <up> <nop>
"nnoremap <down> <nop>
"nnoremap <left> <nop>
"nnoremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>
"nnoremap j gj
"nnoremap k gk


if &term =~ "xterm-debian" || &term =~ "xterm-xfree86" || &term =~ "xterm"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

syntax on

"set background=dark

if has("autocmd")
    filetype plugin on
    filetype indent on
    " Restore cursor position
    au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

    " Filetypes (au = autocmd)
    au FileType helpfile set nonumber      " no line numbers when viewing help
    au FileType helpfile nnoremap <buffer><cr> <c-]>   " Enter selects subject
    au FileType helpfile nnoremap <buffer><bs> <c-T>   " Backspace to go back

    " When using mutt, text width=72
    au FileType mail,tex set textwidth=72
    "au FileType cpp,c,java,sh,pl,php,phtml,asp  set autoindent
    au FileType cpp,c,java,sh,pl,php,phtml,asp,xml,javascript  set smartindent
    nnoremap <C-p> :set invpaste paste?<CR>
    set pastetoggle=<C-p>
    set showmode
    "au FileType cpp,c,java,sh,pl,php,phtml,asp  set cindent
    "au BufRead mutt*[0-9] set tw=72
    " Automatically chmod +x Shell and Perl scripts
    "au BufWritePost   *.sh             !chmod +x %
    "au BufWritePost   *.pl             !chmod +x %
    " File formats
    au BufNewFile,BufRead  *.phtml  set syntax=php
    au BufNewFile,BufRead  *.pls    set syntax=dosini
    au BufNewFile,BufRead  modprobe.conf    set syntax=modconf
    " Ctrl+X O
    autocmd FileType python set omnifunc=pythoncomplete#Complete
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
    autocmd FileType php set omnifunc=phpcomplete#CompletePHP
    autocmd FileType c set omnifunc=ccomplete#Complete
    autocmd FileType php noremap <C-L> :!php -l %<CR>
    autocmd Filetype html,xml,xsl source ~/.vim/closetag.vim
    autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class 
	autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``	

    " Make Sure that Vim returns to the same line when we reopen a file"
    augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \ execute 'normal! g`"zvzz' |
        \ endif
    augroup END
    
endif " has ("autocmd")

augroup filetype
  au BufRead reportbug.* set ft=mail
  au BufRead reportbug-* set ft=mail
augroup END

try
  if filereadable('/etc/papersize')
    let s:papersize = matchstr(system('/bin/cat /etc/papersize'), '\p*')
    if strlen(s:papersize)
      let &printoptions = "paper:" . s:papersize
    endif
    unlet! s:papersize
  endif
catch /E145/
endtry

set showcmd 
set showmatch 
set autowrite 

colorscheme lucius

" ========== Plugin Settings =========="

" wildmenu options

set wildignore+=.hg,.git,.svn " Version Controls"
set wildignore+=*.aux,*.out,*.toc "Latex Indermediate files"
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg "Binary Imgs"
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest "Compiled Object files"
set wildignore+=*.spl "Compiled speolling world list"
set wildignore+=*.sw? "Vim swap files"
set wildignore+=*.DS_Store "OSX SHIT"
set wildignore+=*.luac "Lua byte code"
set wildignore+=migrations "Django migrations"
set wildignore+=*.pyc "Python Object codes"
set wildignore+=*.orig "Merge resolution files"

" Mapping to NERDTree
nnoremap <C-n> :NERDTreeToggle<cr>

" Mini Buffer some settigns."
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

" Tagbar key bindings."
"nmap <leader>l <ESC>:TagbarToggle<cr>
"imap <leader>l <ESC>:TagbarToggle<cr>i
nmap <F8> :TagbarToggle<CR> 

" Tasklist keybindings

map T :TaskList<CR>

" ************************************************************************
" A B B R E V I A T I O N S 

"

abbr #b /************************************************************************
abbr #e  ************************************************************************/

"abbr hosts C:\WINNT\system32\drivers\etc\hosts

" abbreviation to manually enter a timestamp. Just type YTS in insert mode 

iab YTS <C-R>=TimeStamp()<CR>

" Date/Time stamps
" %a - Day of the week
" %b - Month

" %d - Day of the month
" %Y - Year
" %H - Hour
" %M - Minute
" %S - Seconds
" %Z - Time Zone

iab YDATETIME <c-r>=strftime(": %a %b %d, %Y %H:%M:%S %Z")<cr>



" ************************************************************************
"  F U N C T I O N S

"

" first add a function that returns a time stamp in the desired format 
if !exists("*TimeStamp")
    fun TimeStamp()

        return "Last-modified: " . strftime("%d %b %Y %X")
    endfun
endif

" searches the first ten lines for the timestamp and updates using the
" TimeStamp function
if !exists("*UpdateTimeStamp")
function! UpdateTimeStamp()

   " Do the updation only if the current buffer is modified 
   if &modified == 1
       " go to the first line
       exec "1"

      " Search for Last modified: 
      let modified_line_no = search("Last-modified:")
      if modified_line_no != 0 && modified_line_no < 10

         " There is a match in first 10 lines 
         " Go to the : in modified: 
         exe "s/Last-modified: .*/" . TimeStamp()
     endif

 endif
 endfunction
endif

