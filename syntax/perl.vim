" Vim syntax file
" Language:      Perl 5 with MooseX::Declare and Moose keywords
" Version:       0.20
" Maintainer:    Rafael Kitover <rkitover@cpan.org>
" Homepage:      https://github.com/rkitover/perl-vim-mxd
" Bugs/requests: https://github.com/rkitover/perl-vim-mxd/issues
" Last Change:   2013-08-22
" Contributors:  Andy Lester <andy@petdance.com>
"                Oleg Kostyuk <cub@cpan.org>
"                Hinrik Örn Sigurðsson <hinrik.sig@gmail.com>
"                Lukas Mai <l.mai.web.de>
"                Nick Hibma <nick@van-laarhoven.org>
"                Sonia Heimann <niania@netsurf.org>
"                Denis Pokataev
"                Rob Hoelz <rob@hoelz.ro>
"                and many others.
"
" Please download the most recent version first, before mailing
" any comments.
"
" The following parameters are available for tuning the
" perl syntax highlighting, with defaults given:
"
" let perl_include_pod=1
" let perl_string_as_statement=1
" let perl_moose_stuff=1
" unlet perl_no_scope_in_variables
" unlet perl_no_extended_vars
" unlet perl_string_as_statement
" unlet perl_no_sync_on_sub
" unlet perl_no_sync_on_global_var
" let perl_sync_dist = 100
" unlet perl_fold
" unlet perl_fold_blocks
" unlet perl_nofold_packages
" let perl_nofold_subs = 1
" unlet perl_fold_anonymous_subs



if version < 600
  echoerr ">=vim-6.0 is required to run perl.vim"
  finish
elseif exists("b:current_syntax")
  finish
endif

" set some nice defaults people usually don't set, unless overridden
if !exists("perl_include_pod")
  let perl_include_pod=1
endif
if !exists("perl_string_as_statement")
  let perl_string_as_statement=1
endif
if !exists("perl_moose_stuff")
  let perl_moose_stuff=1
endif


if perl_moose_stuff
  " TODO:
  "   fix $foo->Bar->baz(23)->dongs highlighting
  "   make the -> for method calls a different color
  "   make methods a different color than variables

  " Moose, HTML::FormHandler and some other common functions
  syn match perlStatementProc             "\<\%(carp\|class_has\|croak\|has_field\|immutable\|is\|mutable\|reftype\|requires\)\>"

  " Moose Keywords
  syn match perlStatementProc             "\<\%(extends\|with\|has\|before\|after\|around\|super\|override\|inner\|augment\|confess\|blessed\)\>"

  " Moose::Util::TypeConstraints Keywords
  syn match perlStatementProc             "\<\%(type\|subtype\|class_type\|role_type\|maybe_type\|duck_type\|as\|where\|message\|optimize_as\|inline_as\|coerce\|from\|via\|enum\|find_type_constraint\|register_type_constraint\)\>"

  " Test::More, Test::Moose and Test::Exception stuff (except for "is", which is already highlighted.)
  syn match perlStatementProc             "\<\%(plan\|use_ok\|require_ok\|ok\|isnt\|diag\|note\|explain\|like\|unlike\|cmp_ok\|is_deeply\|skip\|can_ok\|isa_ok\|new_ok\|pass\|fail\|skip\|todo_skip\|done_testing\|BAIL_OUT\|meta_ok\|does_ok\|has_attribute_ok\|throws_ok\|dies_ok\|lives_ok\|lives_and\|subtest\)\>"

  " Test::Deep, except SPECIAL COMPARISONS
  syn match perlStatementProc             "\<\%(cmp_deeply\|cmp_bag\|cmp_set\|cmp_methods\|eq_deeply\|cmp_details\|deep_diag\)\>"

  " Test::Differences
  syn match perlStatementProc             "\<\%(eq_or_diff\|eq_or_diff_data\|eq_or_diff_text\|table_diff\|unified_diff\|oldstyle_diff\|context_diff\)\>"

  " Test::*, all functions like all_perl_files_ok/all_pod_coverage_ok/etc
  " may be, will be better something like: \<\%(all_[a-z_]\+_ok\)\>
  syn match perlStatementProc             "\<\%(all_perl_files_ok\|all_critic_ok\|all_pod_coverage_ok\|all_pod_files_spelling_ok\|all_pod_files_ok\|all_cover_ok\)\>"

  " Try::Tiny and Error/Error::Simple
  syn match perlStatementProc             "\<\%(try\|throw\|catch\|except\|otherwise\|finally\)\>"

  " Switch.pm
  syn match perlConditional               "\<\%(switch\|case\)\>"

  syn match perlMethodName                +\%(\h\|::\|['"]\)\%(\w\|::\|\$\|[{}]\)\+["']\?\_s*\|+ contained nextgroup=perlPossibleComma
  syn match perlPossibleComma             +\_s*\%(=>\|,\)\?\_s*\|+ contained nextgroup=perlAnonSubOrMethod
  syn match perlAnonSubOrMethod           +\_s*\%(sub\|method\)\_s*\|+ contained contains=perlFunction nextgroup=perlMethodSignature
  syn match perlMethodSignature           +\_s*\%((\_[^)]*)\)\?\_s*\|+ nextgroup=perlSubAttributes,perlComment contained contains=@perlExpr,perlStatementProc
  syn match perlFunction                  +\<\%(class\|role\|extends\|with\)\>\_s*+ nextgroup=perlPackageRef
  syn match perlFunction                  +\<\%(method\|before\|after\|around\|override\|augment\)\>\_s*+ nextgroup=perlMethodName

  command -nargs=+ HiLink hi def link <args>
  HiLink perlMethodName Function
  delcommand HiLink

  "hilite Moose types
  syn match perlString "\<Any\>\|\<Item\>\|\<Bool\>\|\<Maybe\>\|\<Undef\>\|\<Defined\>\|\<Value\>\|\<Num\>\|\<Int\>\|\<Str\>\|\<ClassName\>\|\<Ref\>\|\<ScalarRef\>\|\<ArrayRef\>\|\<HashRef\>\|\<CodeRef\>\|\<RegexpRef\>\|\<GlobRef\>\|\<FileHandle\>\|\<Object\>\|\<Role\>"

  if !exists("perl_no_sync_on_sub")
    syn sync match perlSync       grouphere NONE "^\s*\<method\>"
    syn sync match perlSync       grouphere NONE "^\s*\<class\>"
    syn sync match perlSync       grouphere NONE "^\s*\<role\>"
  endif

  if exists("perl_fold")
    if !exists("perl_nofold_subs")
      syn region perlSubFold     start="^\z(\s*\)\<class\>.*[^};]$" end="^\z1}\s*\%(#.*\)\=$" transparent fold keepend
      syn region perlSubFold     start="^\z(\s*\)\<role\>.*[^};]$"  end="^\z1}\s*\%(#.*\)\=$" transparent fold keepend
      syn region perlSubFold     start="^\z(\s*\)\<method\>.*[^};]$" end="^\z1}\s*\%(#.*\)\=$" transparent fold keepend
    endif
  endif
endif

"perlcritic comments
hi def link perlCritic PreProc
syn match perlCritic "(#[^#]*)\@<!#\zs#\s*no\s+critic\s*(([a-zA-Z0-9,: ]*)|)\ze"
syn match perlCritic "(#[^#]*)\@<!#\zs#\s*use\s+critic\ze"
syn match perlComment "#.*" contains=perlTodo,perlCritic,@Spell

"perltidy comments, always MUST be placed after "syn match perlComment" definition
hi def link perlTidyComment Comment
hi def link perlTidy PreProc
syn match perlTidy "^\s*#\zs(<<<|>>>)\ze"
syn match perlTidyComment "^\s*#(<<<|>>>).*" contains=perlTidy,@Spell

"perlSharpBang, always MUST be placed after "syn match perlTidyComment" definition
syn match perlSharpBang "^#!.*"

let s:cpo_save = &cpo
set cpo&vim

if exists('&regexpengine')
  let s:regexpengine=&regexpengine
  set regexpengine=1
endif

" POD starts with ^=<word> and ends with ^=cut

if !exists("perl_include_pod") || perl_include_pod == 1
  " Include a while extra syntax file
  syn include @Pod syntax/pod.vim
  unlet b:current_syntax
  if exists("perl_fold")
    syn region perlPOD start="^=[a-z]" end="^=cut" contains=@Pod,@Spell,perlTodo keepend fold extend
    syn region perlPOD start="^=cut" end="^=cut" contains=perlTodo keepend fold extend
  else
    syn region perlPOD start="^=[a-z]" end="^=cut" contains=@Pod,@Spell,perlTodo keepend
    syn region perlPOD start="^=cut" end="^=cut" contains=perlTodo keepend
  endif
else
  " Use only the bare minimum of rules
  if exists("perl_fold")
    syn region perlPOD start="^=[a-z]" end="^=cut" fold
  else
    syn region perlPOD start="^=[a-z]" end="^=cut"
  endif
endif


syn cluster perlTop		contains=TOP

syn region perlBraces start="{" end="}" transparent extend

" All keywords
"
syn match perlConditional		"\<\%(if\|elsif\|unless\|given\|when\|default\)\>"
syn match perlConditional		"\<else\%(\%(\_s\*if\>\)\|\>\)" contains=perlElseIfError skipwhite skipnl skipempty
syn match perlRepeat			"\<\%(while\|for\%(each\)\=\|do\|until\|continue\)\>"
syn match perlOperator			"\<\%(defined\|undef\|eq\|ne\|[gl][et]\|cmp\|not\|and\|or\|xor\|not\|bless\|ref\|do\)\>"
" for some reason, adding this as the nextgroup for perlControl fixes BEGIN
" folding issues...
syn match perlFakeGroup 		"" contained
syn match perlControl			"\<\%(BEGIN\|CHECK\|INIT\|END\|UNITCHECK\)\>\_s*" nextgroup=perlFakeGroup

syn match perlStatementStorage		"\<\%(my\|our\|local\|state\)\>"
syn match perlStatementControl		"\<\%(return\|last\|next\|redo\|goto\|break\)\>"
syn match perlStatementScalar		"\<\%(chom\=p\|chr\|crypt\|r\=index\|lc\%(first\)\=\|length\|ord\|pack\|sprintf\|substr\|uc\%(first\)\=\)\>"
syn match perlStatementRegexp		"\<\%(pos\|quotemeta\|split\|study\)\>"
syn match perlStatementNumeric		"\<\%(abs\|atan2\|cos\|exp\|hex\|int\|log\|oct\|rand\|sin\|sqrt\|srand\)\>"
syn match perlStatementList		"\<\%(splice\|unshift\|shift\|push\|pop\|join\|reverse\|grep\|map\|sort\|unpack\)\>"
syn match perlStatementHash		"\<\%(delete\|each\|exists\|keys\|values\)\>"
syn match perlStatementIOfunc		"\<\%(syscall\|dbmopen\|dbmclose\)\>"
syn match perlStatementFiledesc		"\<\%(binmode\|close\%(dir\)\=\|eof\|fileno\|getc\|lstat\|printf\=\|read\%(dir\|line\|pipe\)\|rewinddir\|say\|select\|stat\|tell\%(dir\)\=\|write\)\>" nextgroup=perlFiledescStatementNocomma skipwhite
syn match perlStatementFiledesc		"\<\%(fcntl\|flock\|ioctl\|open\%(dir\)\=\|read\|seek\%(dir\)\=\|sys\%(open\|read\|seek\|write\)\|truncate\)\>" nextgroup=perlFiledescStatementComma skipwhite
syn match perlStatementVector		"\<vec\>"
syn match perlStatementFiles		"\<\%(ch\%(dir\|mod\|own\|root\)\|glob\|link\|mkdir\|readlink\|rename\|rmdir\|symlink\|umask\|unlink\|utime\)\>"
syn match perlStatementFiles		"-[rwxoRWXOezsfdlpSbctugkTBMAC]\>"
syn match perlStatementFlow		"\<\%(caller\|die\|dump\|eval\|exit\|wantarray\)\>"
syn match perlStatementInclude		"\<\%(require\|import\)\>"
syn match perlStatementInclude		"\<\%(use\|no\)\s\+\%(\%(attributes\|attrs\|autouse\|parent\|base\|big\%(int\|num\|rat\)\|blib\|bytes\|charnames\|constant\|diagnostics\|encoding\%(::warnings\)\=\|feature\|fields\|filetest\|if\|integer\|less\|lib\|locale\|mro\|open\|ops\|overload\|re\|sigtrap\|sort\|strict\|subs\|threads\%(::shared\)\=\|utf8\|vars\|version\|vmsish\|warnings\%(::register\)\=\)\>\)\="
syn match perlStatementProc		"\<\%(alarm\|exec\|fork\|get\%(pgrp\|ppid\|priority\)\|kill\|pipe\|set\%(pgrp\|priority\)\|sleep\|system\|times\|wait\%(pid\)\=\)\>"
syn match perlStatementSocket		"\<\%(accept\|bind\|connect\|get\%(peername\|sock\%(name\|opt\)\)\|listen\|recv\|send\|setsockopt\|shutdown\|socket\%(pair\)\=\)\>"
syn match perlStatementIPC		"\<\%(msg\%(ctl\|get\|rcv\|snd\)\|sem\%(ctl\|get\|op\)\|shm\%(ctl\|get\|read\|write\)\)\>"
syn match perlStatementNetwork		"\<\%(\%(end\|[gs]et\)\%(host\|net\|proto\|serv\)ent\|get\%(\%(host\|net\)by\%(addr\|name\)\|protoby\%(name\|number\)\|servby\%(name\|port\)\)\)\>"
syn match perlStatementPword		"\<\%(get\%(pw\%(uid\|nam\)\|gr\%(gid\|nam\)\|login\)\)\|\%(end\|[gs]et\)\%(pw\|gr\)ent\>"
syn match perlStatementTime		"\<\%(gmtime\|localtime\|time\)\>"

syn match perlStatementMisc		"\<\%(warn\|format\|formline\|reset\|scalar\|prototype\|lock\|tied\=\|untie\)\>"

syn keyword perlTodo			TODO TODO: TBD TBD: FIXME FIXME: XXX XXX: NOTE NOTE: contained

syn region perlStatementIndirObjWrap   matchgroup=perlStatementIndirObj start="\<\%(map\|grep\|sort\|printf\=\|say\|system\|exec\)\>\s*{" end="}" contains=@perlTop,perlBraces extend

syn match perlLabel      "^\s*\h\w*\s*::\@!\%(\<v\d\+\s*:\)\@<!"

" Perl Identifiers.
"
" Should be cleaned up to better handle identifiers in particular situations
" (in hash keys for example)
"
" Plain identifiers: $foo, @foo, $#foo, %foo, &foo and dereferences $$foo, @$foo, etc.
" We do not process complex things such as @{${"foo"}}. Too complicated, and
" too slow. And what is after the -> is *not* considered as part of the
" variable - there again, too complicated and too slow.

" Special variables first ($^A, ...) and ($|, $', ...)
syn match  perlVarPlain		 "$^[ACDEFHILMNOPRSTVWX]\="
syn match  perlVarPlain		 "$[\\\"\[\]'&`+*.,;=%~!?@#$<>(-]"
syn match  perlVarPlain		 "%+"
syn match  perlVarPlain		 "$\%(0\|[1-9]\d*\)"
" Same as above, but avoids confusion in $::foo (equivalent to $main::foo)
syn match  perlVarPlain		 "$::\@!"
" These variables are not recognized within matches.
syn match  perlVarNotInMatches	 "$[|)]"
" This variable is not recognized within matches delimited by m//.
syn match  perlVarSlash		 "$/"

" And plain identifiers
syn match  perlPackageRef	 "[$@#%*&]\%(\%(::\|'\)\=\I\i*\%(\%(::\|'\)\I\i*\)*\)\=\%(::\|'\)\I"ms=s+1,me=e-1 contained

" To not highlight packages in variables as a scope reference - i.e. in
" $pack::var, pack:: is a scope, just set "perl_no_scope_in_variables"
" If you don't want complex things like @{${"foo"}} to be processed,
" just set the variable "perl_no_extended_vars"...

if !exists("perl_no_scope_in_variables")
  syn match  perlVarPlain       "\%([@$]\|\$#\)\$*\%(\I\i*\)\=\%(\%(::\|'\)\I\i*\)*\%(::\|\i\@<=\)" contains=perlPackageRef nextgroup=perlVarMember,perlVarSimpleMember,perlMethod
  syn match  perlVarPlain2                   "%\$*\%(\I\i*\)\=\%(\%(::\|'\)\I\i*\)*\%(::\|\i\@<=\)" contains=perlPackageRef
  syn match  perlFunctionName                "&\$*\%(\I\i*\)\=\%(\%(::\|'\)\I\i*\)*\%(::\|\i\@<=\)" contains=perlPackageRef nextgroup=perlVarMember,perlVarSimpleMember,perlMethod
else
  syn match  perlVarPlain       "\%([@$]\|\$#\)\$*\%(\I\i*\)\=\%(\%(::\|'\)\I\i*\)*\%(::\|\i\@<=\)" nextgroup=perlVarMember,perlVarSimpleMember,perlMethod
  syn match  perlVarPlain2                   "%\$*\%(\I\i*\)\=\%(\%(::\|'\)\I\i*\)*\%(::\|\i\@<=\)"
  syn match  perlFunctionName                "&\$*\%(\I\i*\)\=\%(\%(::\|'\)\I\i*\)*\%(::\|\i\@<=\)" nextgroup=perlVarMember,perlVarSimpleMember,perlMethod
endif

if !exists("perl_no_extended_vars")
  syn cluster perlExpr		contains=perlStatementIndirObjWrap,perlStatementScalar,perlStatementRegexp,perlStatementNumeric,perlStatementList,perlStatementHash,perlStatementFiles,perlStatementTime,perlStatementMisc,perlVarPlain,perlVarPlain2,perlVarNotInMatches,perlVarSlash,perlVarBlock,perlVarBlock2,perlShellCommand,perlFloat,perlNumber,perlStringUnexpanded,perlString,perlQQ,perlArrow,perlBraces
  syn region perlArrow		matchgroup=perlArrow start="->\s*(" end=")" contains=@perlExpr nextgroup=perlVarMember,perlVarSimpleMember,perlMethod contained
  syn region perlArrow		matchgroup=perlArrow start="->\s*\[" end="\]" contains=@perlExpr nextgroup=perlVarMember,perlVarSimpleMember,perlMethod contained
  syn region perlArrow		matchgroup=perlArrow start="->\s*{" end="}" contains=@perlExpr nextgroup=perlVarMember,perlVarSimpleMember,perlMethod contained
  syn match  perlArrow		"->\s*{\s*\I\i*\s*}" contains=perlVarSimpleMemberName nextgroup=perlVarMember,perlVarSimpleMember,perlMethod contained
  syn region perlArrow		matchgroup=perlArrow start="->\s*\$*\I\i*\s*(" end=")" contains=@perlExpr nextgroup=perlVarMember,perlVarSimpleMember,perlMethod contained
  syn region perlVarBlock	matchgroup=perlVarPlain start="\%($#\|[$@]\)\$*{" skip="\\}" end=+}\|\%(\%(<<\%('\|"\)\?\)\@=\)+ contains=@perlExpr nextgroup=perlVarMember,perlVarSimpleMember,perlMethod extend
  syn region perlVarBlock2	matchgroup=perlVarPlain start="[%&*]\$*{" skip="\\}" end=+}\|\%(\%(<<\%('\|"\)\?\)\@=\)+ contains=@perlExpr nextgroup=perlVarMember,perlVarSimpleMember,perlMethod extend
  syn match  perlVarPlain2	"[%&*]\$*{\I\i*}" nextgroup=perlVarMember,perlVarSimpleMember,perlMethod extend
  syn match  perlVarPlain	"\%(\$#\|[@$]\)\$*{\I\i*}" nextgroup=perlVarMember,perlVarSimpleMember,perlMethod extend
  syn region perlVarMember	matchgroup=perlVarPlain start="\%(->\)\={" skip="\\}" end="}" contained contains=@perlExpr nextgroup=perlVarMember,perlVarSimpleMember,perlMethod extend
  syn match  perlVarSimpleMember	"\%(->\)\={\s*\I\i*\s*}" nextgroup=perlVarMember,perlVarSimpleMember,perlMethod contains=perlVarSimpleMemberName contained extend
  syn match  perlVarSimpleMemberName	"\I\i*" contained
  syn region perlVarMember	matchgroup=perlVarPlain start="\%(->\)\=\[" skip="\\]" end="]" contained contains=@perlExpr nextgroup=perlVarMember,perlVarSimpleMember,perlMethod extend
  syn match perlPackageConst	"__PACKAGE__" nextgroup=perlMethod
  syn match  perlMethod		"->\$*\I\i*" contained nextgroup=perlVarSimpleMember,perlVarMember,perlMethod
endif

" File Descriptors
syn match  perlFiledescRead	"<\h\w*>"

syn match  perlFiledescStatementComma	"(\=\s*\u\w*\s*,"me=e-1 transparent contained contains=perlFiledescStatement
syn match  perlFiledescStatementNocomma "(\=\s*\u\w*\s*[^, \t]"me=e-1 transparent contained contains=perlFiledescStatement

syn match  perlFiledescStatement	"\u\w*" contained

" Special characters in strings and matches
syn match  perlSpecialString	"\\\%(\o\{1,3}\|x\%({\x\+}\|\x\{1,2}\)\|c.\|[^cx]\)" contained extend
syn match  perlSpecialStringU2	"\\." extend contained contains=NONE
syn match  perlSpecialStringU	"\\\\" contained
syn match  perlSpecialMatch	"\\[1-9]" contained extend
syn match  perlSpecialMatch	"\\g\%(\d\+\|{\%(-\=\d\+\|\h\w*\)}\)" contained
syn match  perlSpecialMatch	"\\k\%(<\h\w*>\|'\h\w*'\)" contained
syn match  perlSpecialMatch	"{\d\+\%(,\%(\d\+\)\=\)\=}" contained
syn match  perlSpecialMatch	"\[[]-]\=[^\[\]]*[]-]\=\]" contained extend
syn match  perlSpecialMatch	"[+*()?.]" contained
syn match  perlSpecialMatch	"(?[#:=!]" contained
syn match  perlSpecialMatch	"(?[impsx]*\%(-[imsx]\+\)\=)" contained
syn match  perlSpecialMatch	"(?\%([-+]\=\d\+\|R\))" contained
syn match  perlSpecialMatch	"(?\%(&\|P[>=]\)\h\w*)" contained
syn match  perlSpecialMatch	"(\*\%(\%(PRUNE\|SKIP\|THEN\)\%(:[^)]*\)\=\|\%(MARK\|\):[^)]*\|COMMIT\|F\%(AIL\)\=\|ACCEPT\))" contained

" Possible errors
"
" Highlight lines with only whitespace (only in blank delimited here documents) as errors
syn match  perlNotEmptyLine	"^\s\+$" contained
" Highlight "} else if (...) {", it should be "} else { if (...) { " or "} elsif (...) {"
syn match perlElseIfError	"else\_s*if" containedin=perlConditional
syn keyword perlElseIfError	elseif containedin=perlConditional

" Variable interpolation
"
" These items are interpolated inside "" strings and similar constructs.
syn cluster perlInterpDQ	contains=perlSpecialString,perlVarPlain,perlVarNotInMatches,perlVarSlash,perlVarBlock
" These items are interpolated inside '' strings and similar constructs.
syn cluster perlInterpSQ	contains=perlSpecialStringU,perlSpecialStringU2
" These items are interpolated inside m// matches and s/// substitutions.
syn cluster perlInterpSlash	contains=perlSpecialString,perlSpecialMatch,perlVarPlain,perlVarBlock
" These items are interpolated inside m## matches and s### substitutions.
syn cluster perlInterpMatch	contains=@perlInterpSlash,perlVarSlash

" Shell commands
syn region  perlShellCommand	matchgroup=perlMatchStartEnd start="`" end="`" contains=@perlInterpDQ keepend

" Constants
"
" Numbers
syn match  perlNumber	"\<\%(0\%(x\x[[:xdigit:]_]*\|b[01][01_]*\|\o[0-7_]*\|\)\|[1-9][[:digit:]_]*\)\>"
syn match  perlFloat	"\<\d[[:digit:]_]*[eE][\-+]\=\d\+"
syn match  perlFloat	"\<\d[[:digit:]_]*\.[[:digit:]_]*\%([eE][\-+]\=\d\+\)\="
syn match  perlFloat    "\.[[:digit:]][[:digit:]_]*\%([eE][\-+]\=\d\+\)\="

syn match  perlString	"\<\%(v\d\+\%(\.\d\+\)*\|\d\+\%(\.\d\+\)\{2,}\)\>" contains=perlVStringV
syn match  perlVStringV	"\<v" contained


syn region perlParensSQ		start=+(+ end=+)+ extend contained contains=perlParensSQ,@perlInterpSQ keepend
syn region perlBracketsSQ	start=+\[+ end=+\]+ extend contained contains=perlBracketsSQ,@perlInterpSQ keepend
syn region perlBracesSQ		start=+{+ end=+}+ extend contained contains=perlBracesSQ,@perlInterpSQ keepend
syn region perlAnglesSQ		start=+<+ end=+>+ extend contained contains=perlAnglesSQ,@perlInterpSQ keepend

syn region perlParensDQ		start=+(+ end=+)+ extend contained contains=perlParensDQ,@perlInterpDQ keepend
syn region perlBracketsDQ	start=+\[+ end=+\]+ extend contained contains=perlBracketsDQ,@perlInterpDQ keepend
syn region perlBracesDQ		start=+{+ end=+}+ extend contained contains=perlBracesDQ,@perlInterpDQ keepend
syn region perlAnglesDQ		start=+<+ end=+>+ extend contained contains=perlAnglesDQ,@perlInterpDQ keepend


" Simple version of searches and matches
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!m\>\s*\z([^[:space:]'([{<#]\)+ end=+\z1[msixpodualgc]*+ contains=@perlInterpMatch keepend extend
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!m#+ end=+#[msixpodualgc]*+ contains=@perlInterpMatch keepend extend
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!m\s*'+ end=+'[msixpodualgc]*+ contains=@perlInterpSQ keepend extend
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!m\s*/+ end=+/[msixpodualgc]*+ contains=@perlInterpSlash keepend extend
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!m\s*(+ end=+)[msixpodualgc]*+ contains=@perlInterpMatch,perlParensDQ keepend extend

" A special case for m{}, m<> and m[] which allows for comments and extra whitespace in the pattern
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!m\s*{+ end=+}[msixpodualgc]*+ contains=@perlInterpMatch,perlComment,perlBracesDQ extend
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!m\s*<+ end=+>[msixpodualgc]*+ contains=@perlInterpMatch,perlAnglesDQ keepend extend
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!m\s*\[+ end=+\][msixpodualgc]*+ contains=@perlInterpMatch,perlComment,perlBracketsDQ keepend extend

" Below some hacks to recognise the // variant. This is virtually impossible to catch in all
" cases as the / is used in so many other ways, but these should be the most obvious ones.
syn region perlMatch	matchgroup=perlMatchStartEnd start="\%([$@%&*]\@<!\%(\<split\|\<while\|\<if\|\<unless\|\.\.\|[-+*!~(\[{=]\)\s*\)\@<=/\%(/=\)\@!" start=+^/\%(/=\)\@!+ start=+\s\@<=/\%(/=\)\@![^[:space:][:digit:]$@%=]\@=\%(/\_s*\%([([{$@%&*[:digit:]"'`]\|\_s\w\|[[:upper:]_abd-fhjklnqrt-wyz]\)\)\@!+ skip=+\\/+ end=+/[msixpodualgc]*+ contains=@perlInterpSlash extend


" Substitutions
" perlMatch is the first part, perlSubstitution* is the substitution part
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!s\>\s*\z([^[:space:]'([{<#]\)+ end=+\z1+me=e-1 contains=@perlInterpMatch nextgroup=perlSubstitutionGQQ keepend extend
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!s\s*'+  end=+'+me=e-1 contains=@perlInterpSQ nextgroup=perlSubstitutionSQ keepend extend
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!s\s*/+  end=+/+me=e-1 contains=@perlInterpSlash nextgroup=perlSubstitutionGQQ keepend extend
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!s#+  end=+#+me=e-1 contains=@perlInterpMatch nextgroup=perlSubstitutionGQQ keepend extend
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!s\s*(+ end=+)+ contains=@perlInterpMatch,perlParensDQ nextgroup=perlSubstitutionGQQ skipwhite skipempty skipnl keepend extend
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!s\s*<+ end=+>+ contains=@perlInterpMatch,perlAnglesDQ nextgroup=perlSubstitutionGQQ skipwhite skipempty skipnl keepend extend
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!s\s*\[+ end=+\]+ contains=@perlInterpMatch,perlBracketsDQ nextgroup=perlSubstitutionGQQ skipwhite skipempty skipnl keepend extend
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!s\s*{+ end=+}+ contains=@perlInterpMatch,perlBracesDQ nextgroup=perlSubstitutionGQQ skipwhite skipempty skipnl keepend extend
syn region perlSubstitutionGQQ		matchgroup=perlMatchStartEnd start=+\z([^[:space:]'([{<]\)+ end=+\z1[msixpodualgcer]*+ keepend contained contains=@perlInterpDQ extend
syn region perlSubstitutionGQQ		matchgroup=perlMatchStartEnd start=+(+ end=+)[msixpodualgcer]*+ contained contains=@perlInterpDQ,perlParensDQ keepend extend
syn region perlSubstitutionGQQ		matchgroup=perlMatchStartEnd start=+\[+ end=+\][msixpodualgcer]*+ contained contains=@perlInterpDQ,perlBracketsDQ keepend extend
syn region perlSubstitutionGQQ		matchgroup=perlMatchStartEnd start=+{+ end=+}[msixpodualgcer]*+ contained contains=@perlInterpDQ,perlBracesDQ keepend extend extend
syn region perlSubstitutionGQQ		matchgroup=perlMatchStartEnd start=+<+ end=+>[msixpodualgcer]*+ contained contains=@perlInterpDQ,perlAnglesDQ keepend extend
syn region perlSubstitutionSQ		matchgroup=perlMatchStartEnd start=+'+  end=+'[msixpodualgcer]*+ contained contains=@perlInterpSQ keepend extend

" Translations
" perlMatch is the first part, perlTranslation* is the second, translator part.
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!\%(tr\|y\)\>\s*\z([^[:space:]([{<#]\)+ end=+\z1+me=e-1 contains=@perlInterpSQ nextgroup=perlTranslationGQ
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!\%(tr\|y\)#+ end=+#+me=e-1 contains=@perlInterpSQ nextgroup=perlTranslationGQ
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!\%(tr\|y\)\s*\[+ end=+\]+ contains=@perlInterpSQ,perlBracketsSQ nextgroup=perlTranslationGQ skipwhite skipempty skipnl
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!\%(tr\|y\)\s*(+ end=+)+ contains=@perlInterpSQ,perlParensSQ nextgroup=perlTranslationGQ skipwhite skipempty skipnl
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!\%(tr\|y\)\s*<+ end=+>+ contains=@perlInterpSQ,perlAnglesSQ nextgroup=perlTranslationGQ skipwhite skipempty skipnl
syn region perlMatch	matchgroup=perlMatchStartEnd start=+\<\%(::\|'\|->\)\@<!\%(tr\|y\)\s*{+ end=+}+ contains=@perlInterpSQ,perlBracesSQ nextgroup=perlTranslationGQ skipwhite skipempty skipnl
syn region perlTranslationGQ		matchgroup=perlMatchStartEnd start=+\z([^[:space:]([{<]\)+ end=+\z1[cdsr]*+ contained
syn region perlTranslationGQ		matchgroup=perlMatchStartEnd start=+(+ end=+)[cdsr]*+ contains=perlParensSQ contained
syn region perlTranslationGQ		matchgroup=perlMatchStartEnd start=+\[+ end=+\][cdsr]*+ contains=perlBracketsSQ contained
syn region perlTranslationGQ		matchgroup=perlMatchStartEnd start=+{+ end=+}[cdsr]*+ contains=perlBracesSQ contained
syn region perlTranslationGQ		matchgroup=perlMatchStartEnd start=+<+ end=+>[cdsr]*+ contains=perlAnglesSQ contained


" Strings and q, qq, qw and qr expressions

syn region perlStringUnexpanded	matchgroup=perlStringStartEnd start="'" end="'" contains=@perlInterpSQ keepend extend
syn region perlString		matchgroup=perlStringStartEnd start=+"+  end=+"+ contains=@perlInterpDQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!q\>\s*\z([^[:space:]#([{<]\)+ end=+\z1+ contains=@perlInterpSQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!q#+ end=+#+ contains=@perlInterpSQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!q\s*(+ end=+)+ contains=@perlInterpSQ,perlParensSQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!q\s*\[+ end=+\]+ contains=@perlInterpSQ,perlBracketsSQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!q\s*{+ end=+}+ contains=@perlInterpSQ,perlBracesSQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!q\s*<+ end=+>+ contains=@perlInterpSQ,perlAnglesSQ keepend extend

syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!q[qx]\>\s*\z([^[:space:]#([{<]\)+ end=+\z1+ contains=@perlInterpDQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!q[qx]#+ end=+#+ contains=@perlInterpDQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!q[qx]\s*(+ end=+)+ contains=@perlInterpDQ,perlParensDQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!q[qx]\s*\[+ end=+\]+ contains=@perlInterpDQ,perlBracketsDQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!q[qx]\s*{+ end=+}+ contains=@perlInterpDQ,perlBracesDQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!q[qx]\s*<+ end=+>+ contains=@perlInterpDQ,perlAnglesDQ keepend extend

syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!qw\s*\z([^[:space:]#([{<]\)+  end=+\z1+ contains=@perlInterpSQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!qw#+  end=+#+ contains=@perlInterpSQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!qw\s*(+  end=+)+ contains=@perlInterpSQ,perlParensSQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!qw\s*\[+  end=+\]+ contains=@perlInterpSQ,perlBracketsSQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!qw\s*{+  end=+}+ contains=@perlInterpSQ,perlBracesSQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!qw\s*<+  end=+>+ contains=@perlInterpSQ,perlAnglesSQ keepend extend

syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!qr\>\s*\z([^[:space:]#([{<'/]\)+  end=+\z1[imosx]*+ contains=@perlInterpMatch keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!qr\s*/+  end=+/[imosx]*+ contains=@perlInterpSlash keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!qr#+  end=+#[imosx]*+ contains=@perlInterpMatch keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!qr\s*'+  end=+'[imosx]*+ contains=@perlInterpSQ keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!qr\s*(+  end=+)[imosx]*+ contains=@perlInterpMatch,perlParensDQ keepend extend

" A special case for qr{}, qr<> and qr[] which allows for comments and extra whitespace in the pattern
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!qr\s*{+  end=+}[imosx]*+ contains=@perlInterpMatch,perlBracesDQ,perlComment keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!qr\s*<+  end=+>[imosx]*+ contains=@perlInterpMatch,perlAnglesDQ,perlComment keepend extend
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<\%(::\|'\|->\)\@<!qr\s*\[+  end=+\][imosx]*+ contains=@perlInterpMatch,perlBracketsDQ,perlComment keepend extend

" Constructs such as print <<EOF [...] EOF, 'here' documents
"
" XXX Any statements after the identifier are in perlString colour (i.e.
" 'if $a' in 'print <<EOF if $a'). This is almost impossible to get right it
" seems due to the 'auto-extending nature' of regions.
if exists("perl_fold")
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\z(\I\i*\).*+    end=+^\z1$+ contains=@perlInterpDQ fold extend
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\s*"\z([^\\"]*\%(\\.[^\\"]*\)*\)"+ end=+^\z1$+ contains=@perlInterpDQ fold extend
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\s*'\z([^\\']*\%(\\.[^\\']*\)*\)'+ end=+^\z1$+ contains=@perlInterpSQ fold extend
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\s*""+           end=+^$+    contains=@perlInterpDQ,perlNotEmptyLine fold extend
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\s*''+           end=+^$+    contains=@perlInterpSQ,perlNotEmptyLine fold extend
  syn region perlAutoload	matchgroup=perlStringStartEnd start=+<<\s*\(['"]\=\)\z(END_\%(SUB\|OF_FUNC\|OF_AUTOLOAD\)\)\1+ end=+^\z1$+ contains=ALL fold extend
else
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\z(\I\i*\).*+    end=+^\z1$+ contains=@perlInterpDQ
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\s*"\z([^\\"]*\%(\\.[^\\"]*\)*\)"+ end=+^\z1$+ contains=@perlInterpDQ
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\s*'\z([^\\']*\%(\\.[^\\']*\)*\)'+ end=+^\z1$+ contains=@perlInterpSQ
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\s*""+           end=+^$+    contains=@perlInterpDQ,perlNotEmptyLine
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\s*''+           end=+^$+    contains=@perlInterpSQ,perlNotEmptyLine
  syn region perlAutoload	matchgroup=perlStringStartEnd start=+<<\s*\(['"]\=\)\z(END_\%(SUB\|OF_FUNC\|OF_AUTOLOAD\)\)\1+ end=+^\z1$+ contains=ALL
endif


" Class declarations
"
syn match   perlPackageDecl		"\<package\s\+\%(\h\|::\)\%(\w\|::\)*" contains=perlStatementPackage
syn keyword perlStatementPackage	package contained

" Functions
"       sub [name] [(prototype)] {
"
syn match perlSubError "[^[:space:];{#]" contained
if v:version == 701 && !has('patch221')  " XXX I hope that's the right one
    syn match perlSubAttributes ":" contained
else
    syn match perlSubAttributesCont "\h\w*\_s*\%(:\_s*\)\=" nextgroup=@perlSubAttrMaybe contained
    syn region perlSubAttributesCont matchgroup=perlSubAttributesCont start="\h\w*(" end=")\_s*\%(:\_s*\)\=" nextgroup=@perlSubAttrMaybe contained contains=@perlInterpSQ,perlParensSQ
    syn cluster perlSubAttrMaybe contains=perlSubAttributesCont,perlSubError,perlFakeGroup
    syn match perlSubAttributes "" contained nextgroup=perlSubError
    syn match perlSubAttributes ":\_s*" contained nextgroup=@perlSubAttrMaybe
endif
syn match perlSubPrototypeError "(\%(\_s*\%(\%(\\\%([$@%&*]\|\[[$@%&*]\+\]\)\|[$&*]\|[@%]\%(\_s*)\)\@=\|;\%(\_s*[)$@%&*\\]\)\@=\|_\%(\_s*[);]\)\@=\)\_s*\)*\)\@>\zs\_[^)]\+" contained
syn match perlSubPrototype +(\_[^)]*)\_s*\|+ nextgroup=perlSubAttributes,perlComment contained contains=perlSubPrototypeError
syn match perlSubName +\%(\h\|::\|'\w\)\%(\w\|::\|'\w\)*\_s*\|+ contained nextgroup=perlSubPrototype,perlComment

syn match perlFunction +\<sub\>\_s*+ nextgroup=perlSubName

if !exists("perl_no_scope_in_variables")
   syn match  perlFunctionPRef	"\h\w*::" contained
   syn match  perlFunctionName	"\h\w*[^:]" contained
else
   syn match  perlFunctionName	"\h[[:alnum:]_:]*" contained
endif

" The => operator forces a bareword to the left of it to be interpreted as
" a string
syn match  perlString "\I\@<!-\?\I\i*\%(\s*=>\)\@="

" All other # are comments, except ^#!
syn match  perlComment		"#.*" contains=perlTodo,@Spell extend
syn match  perlSharpBang	"^#!.*"

" Formats
syn region perlFormat		matchgroup=perlStatementIOFunc start="^\s*\<format\s\+\k\+\s*=\s*$"rs=s+6 end="^\s*\.\s*$" contains=perlFormatName,perlFormatField,perlVarPlain,perlVarPlain2
syn match  perlFormatName	"format\s\+\k\+\s*="lc=7,me=e-1 contained
syn match  perlFormatField	"[@^][|<>~]\+\%(\.\.\.\)\=" contained
syn match  perlFormatField	"[@^]#[#.]*" contained
syn match  perlFormatField	"@\*" contained
syn match  perlFormatField	"@[^A-Za-z_|<>~#*]"me=e-1 contained
syn match  perlFormatField	"@$" contained

" __END__ and __DATA__ clauses
if exists("perl_fold")
  syntax region perlDATA		start="^__DATA__$" skip="." end="." fold
  syntax region perlDATA		start="^__END__$" skip="." end="." contains=perlPOD,@perlDATA fold
else
  syntax region perlDATA		start="^__DATA__$" skip="." end="."
  syntax region perlDATA		start="^__END__$" skip="." end="." contains=perlPOD,@perlDATA
endif

"
" Folding

if exists("perl_fold")
  " Note: this bit must come before the actual highlighting of the "package"
  " keyword, otherwise this will screw up Pod lines that match /^package/
  if !exists("perl_nofold_packages")
    syn region perlPackageFold start="^package \S\+;\s*\%(#.*\)\=$" end="^1;\=\s*\%(#.*\)\=$" end="\n\+package"me=s-1 transparent fold keepend
  endif
  if !exists("perl_nofold_subs")
    if exists("perl_fold_anonymous_subs") && perl_fold_anonymous_subs
      syn region perlSubFold     start="\<sub\>[^\n;]*{" end="}" transparent fold keepend extend
      syn region perlSubFold     start="\<\%(BEGIN\|END\|CHECK\|INIT\)\>\s*{" end="}" transparent fold keepend
    else
      syn region perlSubFold     start="^\z(\s*\)\<sub\>.*[^};]$" end="^\z1}\s*\%(#.*\)\=$" transparent fold keepend
      syn region perlSubFold start="^\z(\s*\)\<\%(BEGIN\|END\|CHECK\|INIT\|UNITCHECK\)\>.*[^};]$" end="^\z1}\s*$" transparent fold keepend
    endif
  endif

  if exists("perl_fold_blocks")
    syn region perlBlockFold start="^\z(\s*\)\%(if\|elsif\|unless\|for\|while\|until\|given\)\s*(.*)\%(\s*{\)\=\s*\%(#.*\)\=$" start="^\z(\s*\)foreach\s*\%(\%(my\|our\)\=\s*\S\+\s*\)\=(.*)\%(\s*{\)\=\s*\%(#.*\)\=$" end="^\z1}\s*;\=\%(#.*\)\=$" transparent fold keepend
    syn region perlBlockFold start="^\z(\s*\)\%(do\|else\)\%(\s*{\)\=\s*\%(#.*\)\=$" end="^\z1}\s*while" end="^\z1}\s*;\=\%(#.*\)\=$" transparent fold keepend
  endif

  setlocal foldmethod=syntax
  syn sync fromstart
else
  " fromstart above seems to set minlines even if perl_fold is not set.
  if line('$') <= 5000
    syn sync fromstart
  else
    syn sync minlines=0
  endif
endif

command -nargs=+ HiLink hi def link <args>

" NOTE: If you're linking new highlight groups to perlString, please also put
"       them into b:match_skip in ftplugin/perl.vim.

" The default highlighting.
HiLink perlSharpBang		PreProc
HiLink perlControl		PreProc
HiLink perlInclude		Include
HiLink perlSpecial		Special
HiLink perlString		String
HiLink perlCharacter		Character
HiLink perlNumber		Number
HiLink perlFloat		Float
HiLink perlType			Type
HiLink perlIdentifier		Identifier
HiLink perlLabel		Label
HiLink perlStatement		Statement
HiLink perlConditional		Conditional
HiLink perlRepeat		Repeat
HiLink perlOperator		Operator
HiLink perlFunction		Keyword
HiLink perlSubName		Function
HiLink perlSubPrototype		Type
HiLink perlSubAttributes	PreProc
HiLink perlSubAttributesCont	perlSubAttributes
HiLink perlComment		Comment
HiLink perlTodo			Todo
if exists("perl_string_as_statement")
  HiLink perlStringStartEnd	perlStatement
else
  HiLink perlStringStartEnd	perlString
endif
HiLink perlVStringV		perlStringStartEnd
HiLink perlList			perlStatement
HiLink perlMisc			perlStatement
HiLink perlVarPlain		perlIdentifier
HiLink perlVarPlain2		perlIdentifier
HiLink perlArrow		perlIdentifier
HiLink perlFiledescRead		perlIdentifier
HiLink perlFiledescStatement	perlIdentifier
HiLink perlVarSimpleMember	perlIdentifier
HiLink perlVarSimpleMemberName 	perlString
HiLink perlVarNotInMatches	perlIdentifier
HiLink perlVarSlash		perlIdentifier
HiLink perlQQ			perlString
HiLink perlHereDoc		perlString
HiLink perlStringUnexpanded	perlString
HiLink perlSubstitutionSQ	perlString
HiLink perlSubstitutionGQQ	perlString
HiLink perlTranslationGQ	perlString
HiLink perlMatch		perlString
HiLink perlMatchStartEnd	perlStatement
HiLink perlFormatName		perlIdentifier
HiLink perlFormatField		perlString
HiLink perlPackageDecl		perlType
HiLink perlStorageClass		perlType
HiLink perlPackageRef		perlType
HiLink perlStatementPackage	perlStatement
HiLink perlStatementStorage	perlStatement
HiLink perlStatementControl	perlStatement
HiLink perlStatementScalar	perlStatement
HiLink perlStatementRegexp	perlStatement
HiLink perlStatementNumeric	perlStatement
HiLink perlStatementList	perlStatement
HiLink perlStatementHash	perlStatement
HiLink perlStatementIOfunc	perlStatement
HiLink perlStatementFiledesc	perlStatement
HiLink perlStatementVector	perlStatement
HiLink perlStatementFiles	perlStatement
HiLink perlStatementFlow	perlStatement
HiLink perlStatementInclude	perlStatement
HiLink perlStatementProc	perlStatement
HiLink perlStatementSocket	perlStatement
HiLink perlStatementIPC		perlStatement
HiLink perlStatementNetwork	perlStatement
HiLink perlStatementPword	perlStatement
HiLink perlStatementTime	perlStatement
HiLink perlStatementMisc	perlStatement
HiLink perlStatementIndirObj	perlStatement
HiLink perlFunctionName		perlIdentifier
HiLink perlMethod		perlIdentifier
HiLink perlFunctionPRef		perlType
HiLink perlPOD			perlComment
HiLink perlShellCommand		perlString
HiLink perlSpecialAscii		perlSpecial
HiLink perlSpecialDollar	perlSpecial
HiLink perlSpecialString	perlSpecial
HiLink perlSpecialStringU	perlSpecial
HiLink perlSpecialMatch		perlSpecial
HiLink perlDATA			perlComment

" NOTE: Due to a bug in Vim (or more likely, a misunderstanding on my part),
"       I had to remove the transparent property from the following regions
"       in order to get them to highlight correctly.  Feel free to remove
"       these and reinstate the transparent property if you know how.
HiLink perlParensSQ		perlString
HiLink perlBracketsSQ		perlString
HiLink perlBracesSQ		perlString
HiLink perlAnglesSQ		perlString

HiLink perlParensDQ		perlString
HiLink perlBracketsDQ		perlString
HiLink perlBracesDQ		perlString
HiLink perlAnglesDQ		perlString

HiLink perlSpecialStringU2	perlString

" Possible errors
HiLink perlNotEmptyLine		Error
HiLink perlElseIfError		Error
HiLink perlSubPrototypeError	Error
HiLink perlSubError		Error

delcommand HiLink

" Syncing to speed up processing
"
if !exists("perl_no_sync_on_sub")
  syn sync match perlSync	grouphere NONE "^\s*\<package\s"
  syn sync match perlSync	grouphere NONE "^\s*\<sub\>"
  syn sync match perlSync	grouphere NONE "^}"
endif

if !exists("perl_no_sync_on_global_var")
  syn sync match perlSync	grouphere NONE "^$\I[[:alnum:]_:]+\s*=\s*{"
  syn sync match perlSync	grouphere NONE "^[@%]\I[[:alnum:]_:]+\s*=\s*("
endif

if exists("perl_sync_dist")
  execute "syn sync maxlines=" . perl_sync_dist
else
  syn sync maxlines=100
endif

syn sync match perlSyncPOD	grouphere perlPOD "^=[a-z]\S*"
syn sync match perlSyncPOD	grouphere NONE "^=cut"

let b:current_syntax = "perl"

if exists('&regexpengine')
  let &regexpengine=s:regexpengine
  unlet s:regexpengine
endif

let &cpo = s:cpo_save
unlet s:cpo_save

" XXX Change to sts=4:sw=4
" vim:ts=8:sts=2:sw=2:expandtab:ft=vim
