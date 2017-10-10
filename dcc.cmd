@echo off
if [%cmdextversion%] == [] goto NoCmdExt
setlocal EnableExtensions EnableDelayedExpansion
if errorlevel 1 goto NoCmdExt

set batname=DCC
set (c)=%batname%.CMD [Delphi Compiling Batch], v1.00 (c) 2017 by Jin X (jin.x@sources.ru)

set DEBUG=0

:: Default version and bits
set defversion=102
set defbits=32

:: Delphi main paths
set delphipath6=%ProgramFiles(x86)%\RAD Studio\Delphi6
set delphipath7=%ProgramFiles(x86)%\RAD Studio\Delphi7
set delphipath2005=%ProgramFiles(x86)%\RAD Studio\Delphi2005
set delphipath2006=%ProgramFiles(x86)%\RAD Studio\Delphi2006
set delphipath2007=%ProgramFiles(x86)%\RAD Studio\Delphi2007
set delphipath2009=%ProgramFiles(x86)%\RAD Studio\Delphi2009
set delphipath2010=%ProgramFiles(x86)%\RAD Studio\Delphi2010
set delphipathXE=%ProgramFiles(x86)%\RAD Studio\DelphiXE
set delphipathXE2=%ProgramFiles(x86)%\RAD Studio\DelphiXE2
set delphipathXE3=%ProgramFiles(x86)%\RAD Studio\DelphiXE3
set delphipathXE4=%ProgramFiles(x86)%\RAD Studio\DelphiXE4
set delphipathXE5=%ProgramFiles(x86)%\RAD Studio\DelphiXE5
set delphipathXE6=%ProgramFiles(x86)%\RAD Studio\DelphiXE6
set delphipathXE7=%ProgramFiles(x86)%\RAD Studio\DelphiXE7
set delphipathXE8=%ProgramFiles(x86)%\RAD Studio\DelphiXE8
set delphipath10=%ProgramFiles(x86)%\RAD Studio\Delphi10_Seattle
set delphipath101=%ProgramFiles(x86)%\RAD Studio\Delphi101_Berlin
set delphipath102=%ProgramFiles(x86)%\RAD Studio\Delphi102_Tokyo

:: Delphi IDE executable file name
set defaultdelphiide=bds.exe
set delphiide6=delphi32.exe
set delphiide7=delphi32.exe

:: Delphi names (if name != version)
set delphinameXE=XE
set delphinameXE2=XE2
set delphinameXE3=XE3
set delphinameXE4=XE4
set delphinameXE5=XE5
set delphinameXE6=XE6
set delphinameXE7=XE7
set delphinameXE8=XE8
set delphiname10=10 Seattle
set delphiname101=10.1 Berlin
set delphiname102=10.2 Tokyo

:: Delphi x64 support versions
set delphiXE2x64=1
set delphiXE3x64=1
set delphiXE4x64=1
set delphiXE5x64=1
set delphiXE6x64=1
set delphiXE7x64=1
set delphiXE8x64=1
set delphi10x64=1
set delphi101x64=1
set delphi102x64=1

:: Delphi default options (for compiler only)
set delphiopt6_32=-u"%delphipath6%\lib";"%delphipath6%\lib\Indy10"
set delphiopt7_32=-u"%delphipath7%\lib";"%delphipath7%\lib\Indy10"
set delphiopt2005_32=-u"%delphipath2005%\lib";"%delphipath2005%\lib\Indy10"
set delphiopt2006_32=-u"%delphipath2006%\lib";"%delphipath2006%\lib\Indy10"
set delphiopt2007_32=-u"%delphipath2007%\lib";"%delphipath2007%\lib\Indy10"
set delphiopt2009_32=-u"%delphipath2009%\lib";"%delphipath2009%\lib\Indy10"
set delphiopt2010_32=-u"%delphipath2010%\lib";"%delphipath2010%\lib\Indy10"
set delphioptXE_32=-u"%delphipathXE%\lib\win32\release"
set delphioptXE2_32=-u"%delphipathXE2%\lib\win32\release"
set delphioptXE2_64=-u"%delphipathXE2%\lib\win64\release"
set delphioptXE3_32=-u"%delphipathXE3%\lib\win32\release"
set delphioptXE3_64=-u"%delphipathXE3%\lib\win64\release"
set delphioptXE4_32=-u"%delphipathXE4%\lib\win32\release"
set delphioptXE4_64=-u"%delphipathXE4%\lib\win64\release"
set delphioptXE5_32=-u"%delphipathXE5%\lib\win32\release"
set delphioptXE5_64=-u"%delphipathXE5%\lib\win64\release"
set delphioptXE6_32=-u"%delphipathXE6%\lib\win32\release"
set delphioptXE6_64=-u"%delphipathXE6%\lib\win64\release"
set delphioptXE7_32=-u"%delphipathXE7%\lib\win32\release"
set delphioptXE7_64=-u"%delphipathXE7%\lib\win64\release"
set delphioptXE8_32=-u"%delphipathXE8%\lib\win32\release"
set delphioptXE8_64=-u"%delphipathXE8%\lib\win64\release"
set delphiopt10_32=-u"%delphipath10%\lib\win32\release"
set delphiopt10_64=-u"%delphipath10%\lib\win64\release"
set delphiopt101_32=-u"%delphipath101%\lib\win32\release"
set delphiopt101_64=-u"%delphipath101%\lib\win64\release"
set delphiopt102_32=-u"%delphipath102%\lib\win32\release"
set delphiopt102_64=-u"%delphipath102%\lib\win64\release"

:: Delphi additional options (for compiler and IDE)
set delphicompileropt=
set delphiideopt=

:: Default settings
set version=
set bits=%defbits%
set ide=0
set cleanup=1
set makeopt=1
set morecmd=
set startcmd=
set pause=err
set quiet=0
set mypath=%~dp0
if [%1] == [] goto Usage

if [%DEBUG%] == [1] echo ^>^> $DEBUG: Reading params...

:: Read params and set settings
:NextParam
if "%~1" == %1 goto NoParam
if [%1] == [] goto NoParam
if [%1] == [/?] goto Usage
set p=%1*
if %1 == /32 (set bits=32) else (
 if %1 == /64 (set bits=64) else (
  if /i %1 == /ide (set ide=1) else (
   if /i %1 == /c (set ide=0) else (
    if /i %1 == /ca (set cleanup=1) else (
     if /i %1 == /cb (set cleanup=2) else (
      if /i %1 == /c- (set cleanup=0) else (
       if /i %1 == /m (set makeopt=1) else (
        if /i %1 == /m- (set makeopt=0) else (
         if /i %1 == /w (set morecmd=^| more) else (
          if /i %1 == /w- (set morecmd=) else (
           if /i %1 == /s (set startcmd=start "") else (
            if /i %1 == /s- (set startcmd=) else (
             if /i %1 == /p (set pause=all) else (
              if /i %1 == /pe (set pause=err) else (
               if /i %1 == /ps (set pause=ok) else (
                if /i %1 == /p- (set pause=none) else (
                 if /i %1 == /q (set quiet=all) else (
                  if /i %1 == /qe (set quiet=err) else (
                   if /i %1 == /qs (set quiet=ok) else (
                    if /i %1 == /q- (set quiet=none) else (
                     if %p:~0,1% == / (
                       if [%p:~-4,-1%] == [/32] (set bits=32&set p=%p:~0,-3%)
                       if [%p:~-4,-1%] == [x32] (set bits=32&set p=%p:~0,-3%)
                       if [%p:~-4,-1%] == [/64] (set bits=64&set p=%p:~0,-3%)
                       if [%p:~-4,-1%] == [x64] (set bits=64&set p=%p:~0,-3%)
                       set version=!p:~1,-1!
                     ) else goto NoParam
)))))))))))))))))))))
shift
goto NextParam
:NoParam
if [%version%] == [] set version=%defversion%

if [%DEBUG%] == [1] echo ^>^> $DEBUG: version=%version%, bits=%bits%
if [%DEBUG%] == [1] echo ^>^> $DEBUG: ide=%ide%, cleanup=%cleanup%, makeopt=%makeopt%, "morecmd"="%morecmd%", "startcmd"="%startcmd%", pause=%pause%, quiet=%quiet%

set delphipath=!delphipath%version%!
if "%delphipath%" == "" (
  if /i not %quiet% == err (if /i not %quiet% == all (call :ShowMsg "Wrong Delphi version (%version%) is specified ###"))
  goto Quit
)

if [%DEBUG%] == [1] echo ^>^> $DEBUG: delphipath=%delphipath%

set delphiname=!delphiname%version%!
if "%delphiname%" == "" set delphiname=%version%
if bits == 64 (if not [!delphi%version%x64!] == [1] (
  if /i not %quiet% == err (if /i not %quiet% == all (call :ShowMsg "Delphi %delphiname% doesn't support x64 architecture ###"))
  goto Quit
))
if %bits% == 64 set delphiname=%delphiname% (x64)

if [%DEBUG%] == [1] echo ^>^> $DEBUG: delphiname=%delphiname%

if %ide% == 1 (
  set delphiide=!delphiide%version%!
  if "!delphiide%version%!" == "" set delphiide=%defaultdelphiide%
  set delphipath="%delphipath%\bin\!delphiide!"
) else (set delphipath="%delphipath%\bin\dcc%bits%.exe")
if not exist %delphipath% (
  if %ide% == 1 (set type=IDE) else (set type=compiler)
  if /i not %quiet% == err (if /i not %quiet% == all (call :ShowMsg "Delphi %delphiname% !type! executable file is not found ###"))
  goto Quit
)

if [%DEBUG%] == [1] echo ^>^> $DEBUG: full delphipath=%delphipath%

if %ide% == 1 (
  set delphiopt=%delphiideopt%
) else (
  set delphiopt=!delphiopt%version%_%bits%! %delphicompileropt%
)

if [%DEBUG%] == [1] echo ^>^> $DEBUG: delphiopt=%delphiopt%

:: Compilation process
shift
if %cleanup% geq 1 (if exist "%mypath%cleanupdpr.cmd" call "%mypath%cleanupdpr.cmd" %0 %1 %2 %3 %4 %5 %6 %7 %8 %9)
if %ide% == 0 (if %makeopt% == 1 (if /i not [%0] == [-b] (if /i not [%0] == [-m] set delphiopt=-m %delphiopt%)))
if /i not %quiet% == ok (if /i not %quiet% == all (
  if %ide% == 1 (call :ShowMsg "Executing Delphi %delphiname% IDE ###") else (
    if not [%0] == [] (call :ShowMsg "Compiling with Delphi %delphiname% ###") else (call :ShowMsg "Executing Delphi %delphiname% compiler ###")
)))

if [%DEBUG%] == [1] echo ^>^> $DEBUG: command line=%startcmd% %delphipath% %delphiopt% %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %morecmd%

%startcmd% %delphipath% %delphiopt% %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 %morecmd%

set el=%errorlevel%
if %cleanup% == 2 (if exist "%mypath%cleanupdpr.cmd" call "%mypath%cleanupdpr.cmd" -)
if %el% == 0 (call :Pause ok) else (call :Pause err)

if [%DEBUG%] == [1] echo ^>^> $DEBUG: Quitting...
exit /b %el%

:: Procedures
:Usage
echo %(c)%
echo Usage:
echo   %batname% /version[x32^|x64] [/options] [delphi_options] filename(s)
echo.
echo where options are:
echo   /32^|/64 - bitness (this parameter can be specified after '/version' without space, e.g. /XE5/64)
echo   /ide^|/c - run IDE (/ide) or compiler (/c - default)
echo   /ca^|/cb^|/c- - call 'cleanupdpr.cmd': before and after compilation (/ca - default), only before compilation (/cb), never (/c-)
echo   /m^|/m- - add (/m - default) or don't add (/m-) '-m' option if '-b' option is not specified as the first delphi_option (not used for IDE)
echo   /w^|/w- - output with pause on every page using 'more' command (/w) or without pauses (/w- - default)
echo   /s^|/s- - don't wait, run via 'start' command (/s) or wait for process finish (/s- - default)
echo   /p^|/pe^|/ps^|/p- - pause after compilation: always (/p), on error (/pe - default), on success (/ps), never (/p-)
echo   /q^|/qe^|/qs^|/q- - don't show messages: always (/q), on error (/qe), on success (/qs), never (/q- - default, i.e. show all messages)
:Quit
call :Pause err
exit /b 255

:NoCmdExt
echo -----------------------------------------------------------------
echo Командный процессор не поддерживает расширенную обработку команд!
echo -----------------------------------------------------------------
pause > nul
exit /b

:Pause
set pausenow=1
if /i not %pause% == %1 (if /i not %pause% == all set pausenow=0)
if %pausenow% == 1 (if /i %quiet% == %1 (pause>nul) else (if /i %quiet% == all (pause>nul) else (echo.&pause)))
exit /b

:ShowMsg str(#=!)
set _s=%~1&call :StrLen !_s!&call :StrRep !_l! -
echo %_s:#=^^!%
call :StrRep %_l% -
exit /b
:StrLen str
set _=%*&set _l=0&(for /l %%i in (1,1,256) do if #!_! neq # set /a _l+=1&set _=!_:~0,-1!)&exit /b
:StrRep count str
set _=&(for /l %%i in (1,1,%1) do set _=!_!%2)&echo !_!&exit /b
