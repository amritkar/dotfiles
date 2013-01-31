"
" @(#)	This is vimrc for vim/gvim.
"		This vimrc file will automatically configure itself based on
"		the system it runs on (Windows/Unix).
"		This vimrc file has been tested on SPARC/Solaris, Intel/Linux
"		and Windows NT/ME
"
"		Config Notes:
"		Unix:
"			1. Create a directory: ~/vimtmp and move .viminfo there
"			2. Link: ln -s .vimrc .gvimrc	
"			3. If gvim is executed, .vimrc will be executed twice.
"			   First as .vimrc and then as .gvimrc. This is good!
"		Windows:
"			1. Create a directory: $HOME\vimtmp
"			2. Move .viminfo (if it exists) to $HOME\vimtmp	
"			3. Name .vimrc as _vimrc in $HOME 	
"
"			   Make sure there is no _gvimrc in $HOME. This creates a conflict.	
"			4. Optional. In the Windows Global settings below, change the preferences
"			   to suit your needs.
"
" @(#)	01/07/25-03/07/21 xaos@darksmile.net, "http://www.darksmile.net/vimindex.html"
"
" Windows Global Settings. Font and scheme preferences
"
let mywinfont="Lucida_Console:h12:cANSI"
let $myscheme=$VIMRUNTIME . '\colors\koehler.vim'
let $myxscheme=$VIMRUNTIME . '/colors/koehler.vim'
" set spell
"
" If full gui has been reached then run these additional commands. Unix only!
"
if has("gui_running") && &term == "builtin_gui"
	if &syntax == "" && isdirectory($VIMRUNTIME)
		syntax on
		set hlsearch
	endif
	map <F37> :set list!
	imap <F37> :set list!a
	highlight Normal guibg=white
	highlight Cursor guibg=green guifg=NONE
	set guifont=-schumacher-clean-medium-r-normal-*-*-160-*-*-c-*-iso646.1991-irv
	"
	" This is also nice. Run as :F2 to change font
	command! F2 set guifont=-dec-terminal-medium-r-wide-*-*-140-*-*-c-*-iso8859-1
	if filereadable( $myxscheme )
		source $myxscheme
	endif
else
	"
	" This needs to be set up front
	"
	set nocompatible
	"
	" Set up according to platform
	" 
	if has("win32") || has("win16")
		let osys="windows"
		behave mswin
		source $VIMRUNTIME/mswin.vim
	else
		let osys=system('uname -s')
		"
		" What was the name that we were called as?
		"
		let vinvoke=fnamemodify($_, ":p")
		let fullp=substitute(vinvoke, '^\(.*[/]\).*$', '\1', "")
		"
		" It's possible that $VIMRUNTIME does not exist.
		" Let's see if there is a dir vimshare below where we were started
		"
		if isdirectory($VIMRUNTIME) == 0
			let vimshare=fullp . "vimshare"
			if isdirectory(vimshare) == 1
				let $VIMRUNTIME=vimshare . "/vim" . substitute(v:version, "50", "5", "")
				let &helpfile=vimshare . "/vim" . substitute(v:version, "50", "5", "") . "/doc/help.txt"
			endif
		endif
	endif
	if &t_Co > 2
		set bg=dark
		syntax on
		set hlsearch
		highlight Comment term=bold ctermfg=2
		highlight Constant term=underline ctermfg=7
	endif
	if osys == "windows" && has("gui_running")
		syntax on
		set hlsearch
		let &guifont=mywinfont
		if filereadable( $myscheme )
			source $myscheme
		endif
	endif
	if version >= 600
		autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif 
		let g:tex_flavor='latex'
		set grepprg=grep\ -nH\ $*
		"
		" fold options
		"
		let fortran_fold=1
		let fortran_fold_conditionals=1
		set foldmethod=syntax
		"
		"set foldmethod=indent
		"set foldmethod=expr
		"set foldexpr=getline(v:lnum)[0]==\"\\t\"
	else
		autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
	endif
	"
	" Find out where the backups and viminfo are kept
	" If term is blank at this point, this must be a windows system
	"
	if osys == "windows"
		let vimtdir=$HOME . '\vimtmp'
		if isdirectory(vimtdir) == 0
			let vimtdir=$HOME
		endif 
		let &viminfo="'20," . '%,n' . vimtdir . '\.viminfo'
	else
		let myuid=substitute(system('id'), '^uid=\([0-9]*\)(.*', '\1', "")
		let vimtdir=$HOME . '/vimtmp'
		if isdirectory(vimtdir) == 0
			let vimtdir=$HOME
		endif 
		if myuid == "0" && osys =~ "SunOS"
			let vimtdir='/var/vimtmp'
		endif
		let &viminfo="'20," . '%,n' . vimtdir . '/.viminfo'
		"
		" Setup a proper include file path
		"
		if $INCLUDE == ""
			if osys =~ "SunOS"
				let &path="/usr/include,/usr/openwin/include,/usr/dt/include,/usr/local/include"
			else
				let &path="/usr/include,/usr/X11R6/include,/usr/openwin/include,/usr/local/include"
			endif
		else
			let &path=substitute($INCLUDE, ':', ',', "g")
		endif
	endif
	set backup
	set backupdir=~/.vimtemp
	set history=100
	set nowrap
	set tabstop=4
	set shiftwidth=4
	set statusline=%<%F%h%m%r%=\[%B\]\ %l,%c%V\ %P
	set laststatus=2
	set showcmd
	set gcr=a:blinkon0
	set errorbells
	set nowarn
	set ignorecase
	set smartcase
	"
	" The following function and maps allow for [[ and ]] to search for a
	" single char under the cursor.
	" 
	function Cchar()
		let c = getline(line("."))[col(".") - 1]
		let @/ = c
	endfunction
	map [[ :call Cchar()n
	map ]] :call Cchar()N
	"
	" Use F4 to switch between hex and ASCII editing
	"
	function Fxxd()
		let c=getline(".")
		if c =~ '^[0-9a-f]\{7}:'
			:%!xxd -r
		else
			:%!xxd -g4
		endif
	endfunction
	map <F4> :call Fxxd()
	map  gf
	if &term == "xterm"
		" Delete
		map  x
		" End
		map [26~ 100%
		" Home
		map [25~ :1
		" F2
		map [12~ :w
		imap [12~ :wi
		" F3
		map [13~ :q
		imap [13~ :q
		" F10
		map [21~ :wq!
		imap [21~ :wq!
		" F11
		map [24~ :set list!
		imap [24~ :set list!i
	else
		if osys != "windows" 
			map [3~ x	" Delete
			imap [3~  
			map [2~ i		" Insert
			imap [2~ 
			map [4~ 100%	" End
			map [1~ :1	" Home
			map [5~ 	" PgUp
			map [6~ 	" PgDn
			map [[A :h		" F1
			map [28~ :h 
		endif
	endif
	map <F2> :w
	imap <F2> :wa
	map <F3> :q
	imap <F3> :q
	map <F10> :wq!
	imap <F10> :wq!
endif
"
" Some commands which must be run twice!
" 
if version >= 600
	set cmdwinheight&
endif
set cmdheight&


" This is an example vimrc that should work for testing purposes.
" Integrate the VimOrganizer specific sections into your own
" vimrc if you wish to use VimOrganizer on a regular basis. . .

"===================================================================
" THE NECESSARY STUFF"
" THe three lines below are necessary for VimOrganizer to work right
" =================================================================
filetype plugin indent on
" and then put these lines in vimrc somewhere after the line above
au! BufRead,BufWrite,BufWritePost,BufNewFile *.org 
au BufEnter *.org            call org#SetOrgFileType()
" let g:org_command_for_emacsclient = emacsclient

"==============================================================
" THE UNNECESSARY STUFF"
"=============================================================
"  Everything below here is a customization.  None are needed.
"============================================================

" vars below are used to define default Todo list and
" default Tag list.  Both of these can also be defined 
" on a document-specific basis by config lines in a file.
" See :h vimorg-todo-metadata and/or :h vimorg-tag-metadata
" 'TODO | DONE' is the default,so not really necessary to define it at all
let g:org_todo_setup='TODO | DONE'
" OR, e.g.,:
"let g:org_todo_setup='TODO NEXT STARTED | DONE CANCELED'

" include a tags setup string if you want:
let g:org_tags_alist='{@home(h) @work(w) @tennisclub(t)} {easy(e) hard(d)} {computer(c) phone(p)}'
"
" g:org_agenda_dirs specify directories that, along with 
" their subtrees, are searched for list of .org files when
" accessing EditAgendaFiles().  Specify your own here, otherwise
" default will be for g:org_agenda_dirs to hold single
" directory which is directory of the first .org file opened
" in current Vim instance:
" Below is line I use in my Windows install:
" NOTE:  case sensitive even on windows.
let g:org_agenda_select_dirs=["~/desktop/org_files"]
let g:agenda_files = split(glob("~/desktop/org_files/org-mod*.org"),"\n")

" ---------------------
" Emacs setup
" --------------------
" To use Emacs you will need to define the client.  On
" Linux/OSX this is typically simple, just:
"let g:org_command_for_emacsclient = 'emacsclient'
"
"On Windows it is more complicated, and probably involves creating
" a 'soft link' to the emacsclient executable (which is 'emacsclientw')
" See :h vimorg-emacs-setup
"let g:org_command_for_emacsclient = 'c:\users\herbert\emacsclientw.exe'

" ---------------------
" Custom Agenda Searches
" --------------------
" the assignment to g:org_custom_searches below defines searches that a 
" a user can then easily access from the Org menu or the Agenda Dashboard.
" (Still need to add help on how to define them, assignment below
" is hopefully illustrative for now. . . . )
let g:org_custom_searches = [
	    \  { 'name':"Next week's agenda", 'type':'agenda', 
	    \              'agenda_date':'+1w','agenda_duration':'w'}
            \, { 'name':"Next week's TODOS", 'type':'agenda', 
            \    'agenda_date':'+1w','agenda_duration':'w','spec':'+UNFINISHED_TODOS'}
	    \, { 'name':'Home tags', 'type':'heading_list', 'spec':'+HOME'}
	    \, { 'name':'Home tags', 'type':'sparse_tree', 'spec':'+HOME'}
	    \           ]

" --------------------------------
" Custom colors
" --------------------------------"
" OrgCustomColors() allows a user to set highlighting for particular items
function! OrgCustomColors()
    " various text item "highlightings" are below
    " these are the defaults.  Uncomment and change a line if you
    " want different highlighting for the element
    "
    " below are defaults for any TODOS you define.  TODOS that
    " come before the | in a definition will use  'NOTDONETODO'
    " and those that come after are DONETODO
    "hi! DONETODO guifg=green ctermfg=green
    "hi! NOTDONETODO guifg=red ctermfg=lightred

    " heading level highlighting is done in pairs, one for the
    " heading when unfoled and one for folded.  Default is to make
    " them the same except for the folded version being bold:
    " assign OL1 pair for level 1, OL2 pair for level 2, etc.
    "hi! OL1 guifg=somecolor guibg=somecolor 
    "hi! OL1Folded guifg=somecolor guibg=somecolor gui=bold


    " tags are lines below headings that have :colon:separated:tags:
    "hi! Org_Tag guifg=lightgreen ctermfg=blue

    "  lines that begin with '#+' in column 0 are config lines
    "hi! Org_Config_Line guifg=darkgray ctermfg=magenta

    "drawers are :PROPERTIES: and :LOGBOOK: lines and their associated
    " :END: lines
    "hi! Org_Drawer guifg=pink ctermfg=magenta
    "hi! Org_Drawer_Folded guifg=pink ctermfg=magenta gui=bold cterm=bold

    " this applies to value names in :PROPERTIES: blocks 
    "hi! Org_Property_Value guifg=pink ctermfg=magenta

    " three lines below apply to different kinds of blocks
    "hi! Org_Block guifg=#555555 ctermfg=magenta
    "hi! Org_Src_Block guifg=#555555 ctermfg=magenta
    "hi! Org_Table guifg=#888888 guibg=#333333 ctermfg=magenta

    " dates are date specs between angle brackets (<>) or square brackets ([])
    "hi! Org_Date guifg=magenta ctermfg=magenta gui=underline cterm=underline

    " Org_Star is used to "hide" initial asterisks in a heading
    "hi! Org_Star guifg=#444444 ctermfg=darkgray

    "hi! Props guifg=#ffa0a0 ctermfg=gray

    " bold, itals, underline, and code are highlights applied
    " to character formatting
    "hi! Org_Code guifg=darkgray gui=bold ctermfg=14
    "hi! Org_Itals gui=italic guifg=#aaaaaa ctermfg=lightgray
    "hi! Org_Bold gui=bold guifg=#aaaaaa ctermfg=lightgray
    "hi! Org_Underline gui=underline guifg=#aaaaaa ctermfg=lightgray
    "hi! Org_Lnumber guifg=#999999 ctermfg=gray

    " these lines apply to links: [[link]], and [[link][link desc]]
    "if has("conceal")
    "    hi! default linkends guifg=blue ctermfg=blue
    "endif
    "hi! Org_Full_Link guifg=cyan gui=underline ctermfg=lightblue cterm=underline
    "hi! Org_Half_Link guifg=cyan gui=underline ctermfg=lightblue cterm=underline

    "  applies to the Heading line that can be displayed in column view
    "highlight OrgColumnHeadings guibg=#444444 guifg=#aaaaaa gui=underline

    " Use g:org_todo_custom_highlights to set up highlighting for individual
    " TODO items.  Without this all todos that designate an uninished state 
    " will be highlighted using NOTDONETODO highlight (see above) 
    " and all todos that designate a finished state will be highlighted using
    " the DONETODO highlight (see above).
    let g:org_todo_custom_highlights = 
               \     { 'NEXT': { 'guifg':'#888888', 'guibg':'#222222',
               \              'ctermfg':'gray', 'ctermbg':'darkgray'},
               \      'WAITING': { 'guifg':'#aa3388', 
               \                 'ctermfg':'red' } }

endfunction

" below are two examples of Org-mode "hook" functions
" These present opportunities for end-user customization
" of how VimOrganizer works.  For more info see the 
" documentation for hooks in Emacs' Org-mode documentation:
" http://orgmode.org/worg/org-configs/org-hooks.php#sec-1_40
"
" These two hooks are currently the only ones enabled in 
" the VimOrganizer codebase, but they are easy to add so if
" there's a particular hook you want go ahead and request it
" or look for where these hooks are implemented in 
" /ftplugin/org.vim and use them as example for placing your
" own hooks in VimOrganizer:
function! Org_property_changed_functions(line,key, val)
        "call confirm("prop changed: ".a:line."--key:".a:key." val:".a:val)
endfunction
function! Org_after_todo_state_change_hook(line,state1, state2)
        "call confirm("changed: ".a:line."--key:".a:state1." val:".a:state2)
        "call OrgConfirmDrawer("LOGBOOK")
        "let str = ": - State: " . org#Pad(a:state2,10) . "   from: " . Pad(a:state1,10) .
        "            \ '    [' . org#Timestamp() . ']'
        "call append(line("."), repeat(' ',len(matchstr(getline(line(".")),'^\s*'))) . str)
endfunction


