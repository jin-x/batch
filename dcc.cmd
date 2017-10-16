@echo off
if [%cmdextversion%] == [] goto NoCmdExt
setlocal EnableExtensions
if errorlevel 1 goto NoCmdExt

set DEBUG=0

set (c)=DCC.CMD [Delphi Compiling Batch], v1.10 (c) 2017 by Jin X (jin.x@sources.ru)

:: VERSION HISTORY
::
:: v1.10 (16.10.2017)
:: [!] Settings are taken out to 'dcc.config.cmd' file
:: [+] Default batch options can be specified in 'dcoptions' environment variable (that declared in 'dcc.config.cmd')
:: [+] Added 'x86' suffix for '/version' option
:: [+] Added '/i', '/ii' and '/i-' options to avoid multiple instance run
:: [+] Added '/si' option (run via 'start' command for IDE only)
:: [+] Added aliases for compiler versions in 'dcc.config.cmd' (you can use '/07' option instead of '/2007' if setting 'delphiveralias_07=2007' is added)
:: [+] More settings for compiler and IDE (some of variables are renamed): 'delphiexeVERSION_BITS', 'defdelphiexe_BITS', 'delphiideexeVERSION', 'defdelphiideexe',
::     'delphioptVERSION_BITS', 'defdelphiopt_BITS', 'delphiideoptVERSION', 'defdelphiideopt'
:: [+] Executable filename settings ('delphiexeVERSION_BITS', 'defdelphiexe_BITS', 'delphiideexeVERSION', 'defdelphiideexe') can contain full paths to EXE or just paths relatively to %delphipath%;
::     you can also specify a command line with prefix '@' (like '@call MyDelphi.bat') or '@@' if you want to ignore '/s' (run via 'start') option (like '@@call MyDelphi.bat');
::     add hyphen '-' after '@' or '@@' if you don't want to use any options instead of command line parameters (like '@-call MyDelphi.bat' or '@@-call MyDelphi.bat')
:: [+] Option settings 'delphioptVERSION_BITS', 'defdelphiopt_BITS', 'delphiideoptVERSION' and 'defdelphiideopt' can be set as single hyphen '-' to cancel options (and don't use 'defXXX' options);
::     this rule doesn't apply to 'extradelphiopt' and 'extradelphiideopt' or any other settings
:: [-] Fixed some bugs (e.g. '/ca' and '/cb' options worked vice versa) and many internal changes are made; one russian string is translated into English :)
::
:: v1.00 (10.10.2017 and earlier)
:: [!] The first version!

:: Default settings
set version=
set bits=
set ide=0
set cleanup=1
set makeopt=1
set delymultirun=0
set moreopt=0
set startopt=0
set pause=err
set quiet=0

set "batpath=%~dp0"
set configfile="%~dpn0.config.cmd"

if [%DEBUG%] == [1] echo ^>^> $DEBUG: Getting config form %configfile%...

:: Reading settings and process params
if not exist %configfile% (
  call :ShowMsg "Config file %configfile% is not found ###"
  goto :QuitErr
)

call %configfile%

setlocal EnableDelayedExpansion

set "p=%~1"
if not defined p goto Usage

if [%DEBUG%] == [1] echo ^>^> $DEBUG: Processing params...

set optpass=1
call :CheckParam !dcoptions!
set optpass=2

:CheckParam options
set "p=%~1"
if not defined p goto NoParam
if !p! == /? (if not %optpass% == 1 goto Usage)
if !p! == /32 (set bits=32
) else if !p! == /64 (set bits=64
) else if /i !p! == /ide (set ide=1
) else if /i !p! == /c (set ide=0
) else if /i !p! == /ca (set cleanup=2
) else if /i !p! == /cb (set cleanup=1
) else if /i !p! == /c- (set cleanup=0
) else if /i !p! == /m (set makeopt=1
) else if /i !p! == /m- (set makeopt=0
) else if /i !p! == /i (set delymultirun=all
) else if /i !p! == /ii (set delymultirun=ide
) else if /i !p! == /i- (set delymultirun=0
) else if /i !p! == /w (set moreopt=1
) else if /i !p! == /w- (set moreopt=0
) else if /i !p! == /s (set startopt=1
) else if /i !p! == /si (set startopt=ide
) else if /i !p! == /s- (set startopt=0
) else if /i !p! == /p (set pause=all
) else if /i !p! == /pe (set pause=err
) else if /i !p! == /ps (set pause=ok
) else if /i !p! == /p- (set pause=0
) else if /i !p! == /q (set quiet=all
) else if /i !p! == /qe (set quiet=err
) else if /i !p! == /qs (set quiet=ok
) else if /i !p! == /q- (set quiet=0
) else if "!p:~0,1!" == "/" (
  set b=!p:~-3,3!
  if !b! == /32 (set bits=32&set p=!p:~0,-3!
  ) else if !b! == x86 (set bits=32&set p=!p:~0,-3!
  ) else if !b! == x32 (set bits=32&set p=!p:~0,-3!
  ) else if !b! == /64 (set bits=64&set p=!p:~0,-3!
  ) else if !b! == x64 (set bits=64&set p=!p:~0,-3!)
  set version=!p:~1,1000!
) else goto NoParam
shift
goto CheckParam
:NoParam
if %optpass% == 1 exit /b

if not defined version (set version=!defversion!) else (if defined delphiveralias_!version! set "version=!delphiveralias_%version%!")
if not defined bits set bits=!defbits!

if [%DEBUG%] == [1] echo ^>^> $DEBUG: version=!version!, bits=!bits!
if [%DEBUG%] == [1] echo ^>^> $DEBUG: ide=!ide!, cleanup=!cleanup!, makeopt=!makeopt!, moreopt=!moreopt!, startopt=!startopt!, pause=!pause!, quiet=!quiet!

set "delphipath=!delphipath%version%!"
if not defined delphipath (
  if /i not !quiet! == err (if /i not !quiet! == all (call :ShowMsg "Wrong Delphi version (!version!) is specified ###"))
  goto QuitErr
)

if [%DEBUG%] == [1] echo ^>^> $DEBUG: delphipath=!delphipath!

set "delphiname=!delphiname%version%!"
if not defined delphiname set delphiname=!version!
if !bits! == 64 (if not "!delphi%version%x64!" == "1" (
  if /i not !quiet! == err (if /i not !quiet! == all (call :ShowMsg "Delphi !delphiname! doesn't support x64 architecture ###"))
  goto QuitErr
))
if !bits! == 64 set delphiname=!delphiname! (x64)

if [%DEBUG%] == [1] echo ^>^> $DEBUG: delphiname=!delphiname!

if !ide! == 1 (
  set "delphiexe=!delphiideexe%version%!"
  if not defined delphiexe set delphiexe=!defdelphiideexe!
) else (
  set "delphiexe=!delphiexe%version%_%bits%!"
  if not defined delphiexe set "delphiexe=!defdelphiexe_%bits%!"
)

if [%DEBUG%] == [1] echo ^>^> $DEBUG: delphiexe=!delphiexe!

set isexe=1
if "!delphiexe:~0,1!" == "@" (
  set delphiexe=!delphiexe:~1,1000!
  if "!delphiexe:~0,1!" == "@" (
    set delphiexe=!delphiexe:~1,1000!
    set startopt=0
  )
  set isexe=0
)

set nodelphiopt=0
if "!delphiexe:~0,1!" == "-" (
  set delphiexe=!delphiexe:~1,1000!
  set nodelphiopt=1
)

if %isexe% == 1 (
  set c=!delphipath:~-1,1!
  if exist "!delphiexe!" (set delphifullexe="!delphiexe!"
  ) else if !c! == \ (set delphifullexe="!delphipath!!delphiexe!"
  ) else if !c! == / (set delphifullexe="!delphipath!!delphiexe!"
  ) else set delphifullexe="!delphipath!\!delphiexe!"
) else (
  set delphifullexe=!delphiexe!
)

if [%DEBUG%] == [1] echo ^>^> $DEBUG: delphifullexe=!delphifullexe!
if [%DEBUG%] == [1] echo ^>^> $DEBUG: nodelphiopt=!nodelphiopt!, isexe=!isexe!, startopt=!startopt!

if %isexe% == 1 (
  if !ide! == 1 (set type=IDE) else (set type=compiler)
  if not exist !delphifullexe! (
    if /i not !quiet! == err (if /i not !quiet! == all (call :ShowMsg "Delphi !delphiname! !type! executable file is not found ###"))
    goto QuitErr
  )
  set deny=0
  if !delymultirun! == all (set deny=1
  ) else if !delymultirun! == ide (if !ide! == 1 set deny=1)
  if !deny! == 1 (
    call :GetName n "!delphiexe!"
    set isrun=0
    for /f %%a in ('tasklist /fi "imagename eq !n!" ^| find "!n!"') do set isrun=1
    if !isrun! == 1 (
      call :ShowMsg "Delphi !delphiname! !type! (!n!) is already run ###"
      goto QuitErr
    )
  )
)

if !ide! == 1 (
  if %nodelphiopt% == 1 (set delphiopt=!extradelphiideopt!) else (
    set "delphiopt=!delphiideopt%version%!"
    if not defined !delphiopt! set delphiopt=!defdelphiideopt!
    if !delphiopt! == - (set delphiopt=!extradelphiideopt!) else (set delphiopt=!delphiopt! !extradelphiideopt!)
  )
) else (
  if %nodelphiopt% == 1 (set delphiopt=!extradelphiopt!) else (
    set "delphiopt=!delphiopt%version%_%bits%!"
    if not defined delphiopt set "delphiopt=!defdelphiopt_%bits%!"
    if !delphiopt! == - (set delphiopt=!extradelphiopt!) else (set delphiopt=!delphiopt! !extradelphiopt!)
  )
)

if [%DEBUG%] == [1] echo ^>^> $DEBUG: delphiopt=!delphiopt!

:: Compilation process
set "p=%~1"
if !startopt! == ide (if !ide! == 1 set startopt=1)
if !ide! == 0 (if !makeopt! == 1 (if /i not !p! == -b (if /i not !p! == -m set delphiopt=-m !delphiopt!)))

shift
if !cleanup! geq 1 (if exist "%batpath%cleanupdpr.cmd" (
  if [%DEBUG%] == [1] echo ^>^> $DEBUG: cleanup command: "%batpath%cleanupdpr.cmd" %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
  call "%batpath%cleanupdpr.cmd" %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
))
if /i not !quiet! == ok (if /i not !quiet! == all (
  if !ide! == 1 (call :ShowMsg "Executing Delphi !delphiname! IDE ###"
  ) else if defined p (call :ShowMsg "Compiling with Delphi !delphiname! ###"
  ) else call :ShowMsg "Executing Delphi !delphiname! compiler ###"
))

if !startopt! == 1 (
  if !moreopt! == 1 (
    if [%DEBUG%] == [1] echo ^>^> $DEBUG: command line=start "" !delphifullexe! !delphiopt! %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 ^| more
    start "" !delphifullexe! !delphiopt! %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 | more
  ) else (
    if [%DEBUG%] == [1] echo ^>^> $DEBUG: command line=start "" !delphifullexe! !delphiopt! %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
    start "" !delphifullexe! !delphiopt! %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
  )
) else (
  if !moreopt! == 1 (
    if [%DEBUG%] == [1] echo ^>^> $DEBUG: command line=!delphifullexe! !delphiopt! %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 ^| more
    !delphifullexe! !delphiopt! %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 | more
  ) else (
    if [%DEBUG%] == [1] echo ^>^> $DEBUG: command line=!delphifullexe! !delphiopt! %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
    !delphifullexe! !delphiopt! %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
  )
)

set el=%errorlevel%
if !cleanup! == 2 (if exist "%batpath%cleanupdpr.cmd" (
  if [%DEBUG%] == [1] echo ^>^> $DEBUG: cleanup command: "%batpath%cleanupdpr.cmd" -
  call "%batpath%cleanupdpr.cmd" -
))
if %el% == 0 (call :Pause ok) else (call :Pause err)

if [%DEBUG%] == [1] echo ^>^> $DEBUG: Quitting...
exit /b %el%

:: Procedures
:Usage
echo %(c)%
echo Usage:
echo   DC /version[x86^|x32^|x64] [/options] [delphi_options] filenames
echo.
echo where options are:
echo   /32^|/64 - bitness (this parameter can be specified after '/version' without space, e.g. /XE5/64) [not used for IDE^^!]
echo   /ide^|/c - run IDE (/ide) or compiler (/c - default)
echo   /ca^|/cb^|/c- - call 'cleanupdpr.cmd': before and after compilation (/ca - default), only before compilation (/cb), never (/c-)
echo   /m^|/m- - add (/m - default) or don't add (/m-) '-m' option if '-b' option is not specified as the first delphi_option [not used for IDE^^!]
echo   /i^|/ii^|/i- - deny multiple instance run: for compiler and IDE (/i), IDE only (/ii) or never (/i- - default)
echo   /w^|/w- - output with pause on every page using 'more' command (/w) or without pauses (/w- - default)
echo   /s^|/si^|/s- - don't wait, run via 'start' command: always (/s), for IDE only (/si) or never (/s- - default, i.e. wait for process finish)
echo   /p^|/pe^|/ps^|/p- - pause after compilation: always (/p), on error (/pe - default), on success (/ps) or never (/p-)
echo   /q^|/qe^|/qs^|/q- - don't show messages: always (/q), on error (/qe), on success (/qs) or never (/q- - default, i.e. show all messages)
echo p.s. Suffix 'x32' in '/version' option is the same as 'x86' suffix or '/32' option, suffix 'x64' is the same as '/64' options
:QuitErr
call :Pause err
exit /b 255

:NoCmdExt
echo ---------------------------------------------------------------------------
echo Your command processor doesn't support extensions and/or delayed expansion!
echo ---------------------------------------------------------------------------
pause > nul
exit

:Pause ok/err
set dopause=1
if /i not !pause! == %1 (if /i not !pause! == all set dopause=0)
if %dopause% == 1 (if /i !quiet! == %1 (pause > nul) else (if /i !quiet! == all (pause > nul) else (echo.&pause)))
exit /b

:GetName var filename
set "%1=%~nx2"
exit /b

:ShowMsg str(#=!)
set "_s=%~1"&call :StrLen "!_s!"&call :StrRep !_l! -
set "_s=%_s:#=^!%"&echo !_s!
call :StrRep %_l% -
exit /b
:StrLen str
set "_=%~1"&set _l=0&(for /l %%i in (1,1,256) do if defined _ set /a _l+=1&set _=!_:~0,-1!)&exit /b
:StrRep count str
set _=&(for /l %%i in (1,1,%1) do set _=!_!%2)&echo !_!&exit /b
