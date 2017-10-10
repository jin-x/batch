@echo off

set (c)=re7z.cmd, version 1.13a (c) 2016-2017 by Jin X (jin.x@sources.ru)

:: ������� ���������
::
:: v1.13a (26.08.2017)
:: [-] ��ࠢ���� �訡�� ��⠭���� ERRORLEVEL (����� 5 ��⠭���������� 6).
:: [*] ������訥 ��������� � ⥪���.
::
:: v1.13 (04.11.2016)
:: [+] ��������� ����������� �ᯮ�짮����� WinRAR ����� 7-zip ��� �ᯠ����� ��-rar-��娢�� (��� rar-��娢�� ��� ࠢ�� �ᯮ������ rar) (���� /w).
:: [*] �񣪨� ��ᬥ��᪨� ���������.
::
:: v1.12 (29.09.2016)
:: [*] 1.12a: �񣪨� ��ᬥ��᪨� ���������.
:: [+] ��������� 㤠����� १������饣� ��娢�, �᫨ �� ������� (���� /o).
:: [+] ��������� 㤠����� ��室���� ��娢� (��樨 /d, /dc � /da).
:: [+] ��������� ��⨥ ��ਡ�⮢, ������ 㤠����� (���� /ra ��� ��権 /o, /d, /dc � /da).
:: [*] ������ ��㧠 � ���� ����樨 �ந�室�� ⮫쪮 �� �訡��; ��� �ਭ㤨⥫쭮� ���� �ᯮ���� ���� /pp.
:: [+] ��������� ���� /? (������ ���� �����⢥���).
:: [-] ��ࠢ���� �訡�� �� �뢮�� ᮮ�饭�� �� ������⢨� �����প� ���७��� ��ࠡ�⪨ ������ �������� �����஬.
::
:: v1.11 (15.09.2016)
:: [*] ������� 10 ����⮪ �롮� ����� �६����� �����: �᫨ �६����� ����� 㦥 ������� (���� � ��砩�묨 ��ࠬ�), �।�ਭ������� ��� 9 ����⮪ �����樨 ����� �����.
:: [+] ��������� 㤠����� �६����� ����� (���� /c).
:: [+] �������� ����� ��������� � ����ࠩ�, �뢮��騩�� �� ����᪥ ��� ��ࠬ��஢.
:: [*] ������訥 ��������� � �������� �����⬠�.
::
:: v1.10 (09.09.2016)
:: [+] ��������� ��樨 /x � /p.
:: [-] ��ࠢ���� �訡�� � ࠡ�� ��樨 /m.
:: [*] �६����� ����� ⥯��� ᮧ������ � ��砩�묨 ��ࠬ� � �����, � ����� �� 㤠����� ��������� �६����� ����� ����� �� �뤠����.
:: [+] ��������� ���� �����襭�� ERRORLEVEL (� ᤥ���� ���ᠭ�� ��� ���).
:: [-] ����� 䠩� ���䨣��樨 re7z_config.cmd, �� ����ன�� ⥯��� �࠭���� �����, ���� ��� � ��娢��ࠬ 7z.exe � rar.exe ������� �� ॥���.
:: [*] ��⨬���஢��� ������� �������, ���� ���� �뭥ᥭ� � �⤥��� ��楤���.

if [%cmdextversion%] == [] goto nocmdext
if not cmdextversion 1 goto nocmdext
setlocal EnableExtensions EnableDelayedExpansion
if errorlevel 1 goto nocmdext

set tempdirt=%temp:"=%\re7z~////.tmp
call :GetTicks tempdirn
if not defined ProgramFiles set ProgramFiles=C:\Program Files
call :GetAppPath app7z 7zFM.exe 7z.exe "%ProgramFiles%\7-Zip\"
call :GetAppPath apprar WinRAR.exe rar.exe "%ProgramFiles%\WinRAR\"
call :GetAppPath appwrar WinRAR.exe WinRAR.exe "%ProgramFiles%\WinRAR\"
set opt7z=-t7z -mx=9 -ms=1024f1g -mmt=on -r
set opt7zx=-t7z -mx=9 -myx=9 -md=256m -mmt=on -r

set exitcode=0
set pause=2
if [%1] == [] (goto noparams) else if [%1] == [/?] goto noparams
set multi7z=0
set deldest=0
set delsrc=0
set removeattr=0
set wrarprefer=0
set p2=%2
if [%2] == [] (goto start) else (set p2s=%p2:~0,1%
  if [!p2s!] == [/] (set p2=) else goto shift)
:nextparam
if /i [%2] equ [/x] (set opt7z=%opt7zx%) else (
 if /i [%2] equ [/m] (set multi7z=1) else (
  if /i [%2] equ [/o] (set deldest=1) else (
   if /i [%2] equ [/d] (set delsrc=1) else (
    if /i [%2] equ [/dc] (set delsrc=2) else (
     if /i [%2] equ [/da] (set delsrc=3) else (
      if /i [%2] equ [/ra] (set removeattr=1) else (
       if /i [%2] equ [/w] (set wrarprefer=1) else (
        if /i [%2] equ [/p] (set pause=0) else (
         if /i [%2] equ [/pp] (set pause=1) else (
         goto badparam
))))))))))
:shift
shift /2
if [%2] neq [] goto nextparam

:start
if /i %1 == /c (
  call :GetTempDir *
  set c=0&set d=0&set e=0
  if %removeattr% neq 0 attrib -r -s -h !tempdir! /s /d /l
  for /d %%d in (!tempdir!) do (
    if !c!==0 echo.
    <nul set /p=�������� �६����� ����� "%%d"... 
    rd "%%d" /q /s
    set /a c+=1
    if exist "%%d" (echo �訡��^^!&set /a e+=1) else echo Ok.&set /a d+=1
  )
  if !e! neq 0 set exitcode=4
  call :ShowMsg "������� �६����� �����: !c!, 㤠����: !d!, �訡��: !e!" %exitcode%
  exit /b %exitcode%
)

if not exist %1 goto nosourcefile
if not exist %app7z% goto no7zapp

call :GetTicks tick1
for %%f in (%1) do call :PackOneArc %%f %p2%
if errorlevel 1 exit /b %errorlevel%
call :GetTicks tick2
set /a hs=%tick2%-%tick1%
if %hs% lss 0 set /a hs+=8640000
set /a h=%hs%/360000
set /a m=(%hs%/6000)%%60
set /a s=(%hs%/100)%%60
set /a hs=%hs%%%100
echo.
echo ��饥 �६� ��९������ (������ �ࠢ�����): %h% �� %m% ��� %s%.%hs% ᥪ.
if %pause% == 1 (pause > nul) else if %pause% == 2 if %exitcode% neq 0 pause > nul
exit /b %exitcode%


:PackOneArc arc1 [acr2]
if [%2] == [] (set output="%~dpn1.7z") else (
  if "%~f2" == "%~dp2" (set output="%~dp2%~n1.7z") else (if "%~x2" == "" (set output="%~dpn2.7z") else (set output="%~f2"))
)
if "%~f1" == %output% goto samefiles
if exist %output% (
  if %deldest% neq 0 (
    echo.
    echo �������� १������饣� ��娢�...
    if %removeattr% neq 0 attrib -r -s -h %output% /l
    del %output%
    if exist %output% (goto deldesterror) else echo ��娢 㤠��.
  ) else (
    if %multi7z% == 0 goto alreadyexist7z
  )
)

set i=0
:gentempdir
call :GetTempDir %tempdirn% \
if exist "%tempdir%" (
  set /a i+=1
  set /a tempdirn+=%random%
  if !i! geq 10 (goto tempdirerror) else goto gentempdir
)
md "%tempdir%"
if not exist "%tempdir%" goto tempdirerror
rd "%tempdir%"

set userar=0
if /i "%~x1" equ ".rar" if exist %apprar% set userar=1
if %wrarprefer% neq 0 if exist %appwrar% set userar=2
if %userar% neq 0 (
  if %userar% == 1 (%apprar% x -- %1 "%tempdir%") else (%appwrar% x -ibck -- %1 "%tempdir%")
) else (
  %app7z% x -o"%tempdir%" -- %1
)
if not exist "%tempdir%" goto unpackerror
%app7z% a %opt7z% -- %output% "%tempdir%*"
if not exist %output% goto packerror
if %multi7z% == 0 (
  call :Compare %1 %output%
) else (
  if %delsrc% geq 2 call :DelSrc %1
)

:RemoveTempDir
rd "%tempdir%" /s /q
exit /b

:Compare arc1 arc2
echo.
echo.
echo �ࠢ����� ��娢��...
%app7z% l %1 > "%tempdir%re7z-list1"
%app7z% l %2 > "%tempdir%re7z-list2"
for /f "usebackq tokens=3,5,6,7,8" %%a in ("%tempdir%re7z-list1") do (
  if /i "%%c" equ "files" (
    set size1=%%a
    set files1=%%b
    set folders1=%%d
  )
  if /i "%%c+%%e" equ "files,+folders" (
    set size1=%%a
    set files1=%%b
    set folders1=%%d
  )
)
for /f "usebackq tokens=3,5,6,7,8" %%a in ("%tempdir%re7z-list2") do (
  if /i "%%c" equ "files" (
    set size2=%%a
    set files2=%%b
    set folders2=%%d
  )
  if /i "%%c+%%e" equ "files,+folders" (
    set size2=%%a
    set files2=%%b
    set folders2=%%d
  )
)

echo.
if "%size1%" neq "" (
  if "%size2%" neq "" (
    if "%size1%+%files1%+%folders1%" == "%size2%+%files2%+%folders2%" (
      echo =========================================================
      echo ����ন��� ��室���� � १������饣� ��娢�� �����筮^^!
      echo =========================================================
      if %delsrc% neq 0 call :DelSrc %1
      exit /b
    )
    echo ==============================================================================
    echo ^^!^^!^^! �������� ^^!^^!^^!  ����ন��� ��室���� � १������饣� ��娢�� �� �����筮:
    echo "%~f1" �
    echo "%~f2"
    echo ==============================================================================
    if %delsrc% geq 3 call :DelSrc %1
    set exitcode=2
    exit /b
  )
)
echo ===================================================================
echo �� 㤠���� �ࠢ���� ᮤ�ন��� ��室���� � १������饣� ��娢��:
echo "%~f1" �
echo "%~f2"
echo ===================================================================
if %delsrc% geq 2 call :DelSrc %1
set exitcode=1
exit /b

:DelSrc file
echo.
echo �������� ��室���� ��娢�...
if %removeattr% neq 0 attrib -r -s -h %1 /l
del %1
if exist %1 (echo �� 㤠���� 㤠���� ��娢^^!) else echo ��娢 㤠��.
exit /b

:GetTempDir str lastchar (replace //// in %template% by str)
set tempdir=!tempdirt:////=%~1!%~2
exit /b

:GetAppPath var registrysection filename defaultpath
for /f "skip=2 tokens=1,2* delims= " %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\%2" /v Path') do if /i "%%a+%%b" == "Path+REG_SZ" set %1=%%c
if not defined %1 set %1=%~4
if [!%1:~-1!] neq [\] set %1=!%1!\
set %1="!%1!%3"
exit /b

:GetTicks var
set _t=%time: =0%
set /a %1=1%_t:~9,2%-100+(1%_t:~6,2%-100)*100+(1%_t:~3,2%-100)*6000+(1%_t:~0,2%-100)*360000
exit /b


:noparams
echo.
echo ----------------------------------------------------------------------------------------
echo �� ����� ��室�� 䠩� RAR/ZIP^^!
echo ----------------------------------------------------------------------------------------
echo %(c)%
echo ��९������ ��娢�� RAR/ZIP (� ��㣨� �����ন������ 7z.exe ��� �ᯠ�����) � 7-ZIP
echo ��ଠ� ����᪠: re7z.cmd source [destination] [/options]
echo source - ��室�� 䠩� ��� ��᪠ 䠩���
echo destination - १������騩 䠩� ��� ����� (����� ������ ����稢����� �� ����� ���)
echo /options - ��樨:
echo  /x - �ᯮ�짮���� ���६��쭮� ᦠ⨥ (����� ��������� ࠡ��)
echo  /m - ��ꥤ����� ��᪮�쪮 ��室��� ��娢��, �������� ��᪮� source, � ���� ��娢 7-ZIP
echo       (���� ����� �㤥� ��९������ �⤥�쭮); �᫨ १������騩 ��娢 �������,
echo       �� �㤥� ��࠭�, � 䠩�� �� ��室��� ��娢�� ���� ��������� � ����^^!
echo  /o - ��१����뢠�� (㤠����) १������騩 ��娢, �᫨ �� �������
echo  /d - 㤠���� ��室�� ��娢, �� ⮫쪮 �᫨ ��娢� �������
echo  /dc - 㤠���� ��室�� ��娢, ���� �᫨ �� 㤠���� �஢���� �����筮��� ��娢��
echo  /da - 㤠���� ��室�� ��娢 � �� ��砥, ���� �᫨ ��娢� ࠧ����
echo       (�� ������� ��᪮�쪨� ��権 /d /dc /da �ᯮ������ ��᫥���� ������멦
echo       ��樨 /d, /dc � /da �����������, �᫨ ������ /m)
echo  /ra - ᭨���� ��ਡ��� "⮫쪮 ��� �⥭��", "��⥬��" � "�����" ��। 㤠������
echo       (�. ��樨 /o � /d), ���� ��娢�, ����騥 ����� ��ਡ���, 㤠������ �� ����
echo  /w - �ᯮ�짮����, �� ����������, WinRAR ����� 7-zip ��� �ᯠ����� ��-rar-��娢��
echo       (��� rar-��娢�� �ᥣ�� �ᯮ������ rar, �᫨ �� ��⠭�����)
echo  /p - �� ������ ��� ��᫥ �����襭�� ��९������, /pp - ������ ���� �ᥣ��
echo       �� ������⢨� ������ ��樨 ��㧠 �������� ⮫쪮 �� �訡��
echo re7z.cmd /c [/ra] [/p^|/pp] - 㤠���� �� ࠭�� ᮧ����� �६���� �����
echo ----------------------------------------------------------------------------------------
echo ERRORLEVEL:
echo 0 - �ᯥ譮� �����襭��, ᮤ�ন��� ��娢�� �����筮 (���� ������ ���� /m, ⮣��
echo     �஢�ઠ �����筮�� ��娢�� �� �����⢫����, ���� ������ /c � �� ����� 㤠����)
echo 1 - ��९������ �ந��諠, �� �ࠢ���� ��娢� �� 㤠����
echo 2 - ��९������ �ந��諠, �� ᮤ�ন��� ��娢�� ࠧ��筮
echo 3 - ��室�� 䠩� �� ������
echo 4 - �訡�� ᮧ����� (㤠����� ��� /c) �६����� ����� ���� ��� 㦥 �������
echo 5 - �訡�� �ᯠ����� (�६����� ����� ��᫥ �ᯠ����� �� �������)
echo 6 - �訡�� ��娢�樨 (१������騩 䠩� ��᫥ ��娢�樨 �� ������)
echo 7 - १������騩 ��娢 㦥 �������
echo 8 - �訡�� 㤠����� १������饣� ��娢� (�� 㪠����� ��樨 /o)
echo 10 - ��娢��� 7-ZIP �� ������
echo 20 - 㪠��� ���� � �� �� 䠩�
echo 100 - ����୮ ������ ��ࠬ����
echo 200 - �������� ������ �� �����ন���� ���७��� ��ࠡ��� ������
echo ----------------------------------------------------------------------------------------
pause > nul
exit /b

:nocmdext
echo -----------------------------------------------------------------
echo �������� ������ �� �����ন���� ���७��� ��ࠡ��� ������!
echo -----------------------------------------------------------------
pause > nul
exit /b 200

:nosourcefile
call :ShowMsg "��室�� 䠩� �� ������#" 3
exit /b %exitcode%

:badparam
call :ShowMsg "������ �������⨬� ��ࠬ��� (%2)#" 100
exit /b %exitcode%

:samefiles
call :ShowMsg "������ ���� � �� �� 䠩� ��室���� � १������饣� ��娢��#" 20
exit /b %exitcode%

:alreadyexist7z
call :ShowMsg "���������騩 ��娢 㦥 �������#" 7
exit /b %exitcode%

:deldesterror
call :ShowMsg "�訡�� 㤠����� १������饣� ��娢�#" 8
exit /b %exitcode%

:no7zapp
call :ShowMsg "��娢��� 7-ZIP �� ������#" 10
exit /b %exitcode%

:tempdirerror
call :ShowMsg "�訡�� ᮧ����� �६����� ����� (���� ��� 㦥 ������� � ᤥ���� ᫨誮� ����� ����⮪ ������ ��㣮�� ����� �����), ���஡�� ��� ࠧ#" 4
exit /b %exitcode%

:unpackerror
call :ShowMsg "�訡�� �ᯠ����� RAR/ZIP#" 5
exit /b %exitcode%

:packerror
call :RemoveTempDir
call :ShowMsg "�訡�� ��娢�樨 7-ZIP#" 6
exit /b %exitcode%

:ShowMsg str(#=!) [exitcode=0]
echo.
set exitcode=%2&if #%2==# set exitcode=0
set _s=%~1&call :StrLen !_s!&call :StrRep !_l! -
echo %_s:#=^^!%
call :StrRep %_l% -
if %pause%==1 (pause > nul) else if %pause%==2 if %exitcode% neq 0 pause > nul
exit /b
:StrLen str
set _=%*&set _l=0&(for /l %%i in (1,1,256) do if #!_! neq # set /a _l+=1&set _=!_:~0,-1!)&exit /b
:StrRep count str
set _=&(for /l %%i in (1,1,%1) do set _=!_!%2)&echo !_!&exit /b
