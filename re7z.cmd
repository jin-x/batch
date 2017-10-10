@echo off

set (c)=re7z.cmd, version 1.13a (c) 2016-2017 by Jin X (jin.x@sources.ru)

:: ИСТОРИЯ ИЗМЕНЕНИЙ
::
:: v1.13a (26.08.2017)
:: [-] Исправлена ошибка установки ERRORLEVEL (вместо 5 устанавливалось 6).
:: [*] Небольшие изменения в текстах.
::
:: v1.13 (04.11.2016)
:: [+] Добавлена возможность использования WinRAR вместо 7-zip для распаковки не-rar-архивов (для rar-архивов всё равно используется rar) (опция /w).
:: [*] Лёгкие косметические изменения.
::
:: v1.12 (29.09.2016)
:: [*] 1.12a: Лёгкие косметические изменения.
:: [+] Добавлено удаление результирующего архива, если он существует (опция /o).
:: [+] Добавлено удаление исходного архива (опции /d, /dc и /da).
:: [+] Добавлено снятие атрибутов, мешающих удалению (опция /ra для опций /o, /d, /dc и /da).
:: [*] Теперь пауза в конце операции происходит только при ошибке; для принудительной паузы используйте опцию /pp.
:: [+] Добавлена опция /? (должен быть единственным).
:: [-] Исправлена ошибка при выводе сообщения об отсутствии поддержки расширенной обработки команд командным процессором.
::
:: v1.11 (15.09.2016)
:: [*] Сделано 10 попыток выбора имени временной папки: если временная папка уже существует (даже со случайными цифрами), предпринимается ещё 9 попыток генерации имени папки.
:: [+] Добавлено удаление временных папок (опция /c).
:: [+] Добавлен история изменений и копирайт, выводящийся при запуске без параметров.
:: [*] Небольшие изменения в некоторых алгоритмах.
::
:: v1.10 (09.09.2016)
:: [+] Добавлены опции /x и /p.
:: [-] Исправлена ошибка в работе опции /m.
:: [*] Временная папка теперь создаётся со случайными цифрами в имени, а запрос об удалении найденной временной папки больше не выдаётся.
:: [+] Добавлены коды завершения ERRORLEVEL (и сделано описание для них).
:: [-] Удалён файл конфигурации re7z_config.cmd, все настройки теперь хранятся внутри, причём пути к архиваторам 7z.exe и rar.exe берутся из реестра.
:: [*] Оптимизированы некоторые алгоритмы, часть кода вынесено в отдельные процедуры.

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
    <nul set /p=Удаление временной папки "%%d"... 
    rd "%%d" /q /s
    set /a c+=1
    if exist "%%d" (echo Ошибка^^!&set /a e+=1) else echo Ok.&set /a d+=1
  )
  if !e! neq 0 set exitcode=4
  call :ShowMsg "Найдено временных папок: !c!, удалено: !d!, ошибок: !e!" %exitcode%
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
echo Общее время перепаковки (включая сравнение): %h% час %m% мин %s%.%hs% сек.
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
    echo Удаление результирующего архива...
    if %removeattr% neq 0 attrib -r -s -h %output% /l
    del %output%
    if exist %output% (goto deldesterror) else echo Архив удалён.
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
echo Сравнение архивов...
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
      echo Содержимое исходного и результирующего архивов идентично^^!
      echo =========================================================
      if %delsrc% neq 0 call :DelSrc %1
      exit /b
    )
    echo ==============================================================================
    echo ^^!^^!^^! ВНИМАНИЕ ^^!^^!^^!  Содержимое исходного и результирующего архивов не идентично:
    echo "%~f1" и
    echo "%~f2"
    echo ==============================================================================
    if %delsrc% geq 3 call :DelSrc %1
    set exitcode=2
    exit /b
  )
)
echo ===================================================================
echo Не удалось сравнить содержимое исходного и результирующего архивов:
echo "%~f1" и
echo "%~f2"
echo ===================================================================
if %delsrc% geq 2 call :DelSrc %1
set exitcode=1
exit /b

:DelSrc file
echo.
echo Удаление исходного архива...
if %removeattr% neq 0 attrib -r -s -h %1 /l
del %1
if exist %1 (echo Не удалось удалить архив^^!) else echo Архив удалён.
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
echo Не задан исходный файл RAR/ZIP^^!
echo ----------------------------------------------------------------------------------------
echo %(c)%
echo Перепаковка архивов RAR/ZIP (и других поддерживаемых 7z.exe для распаковки) в 7-ZIP
echo Формат запуска: re7z.cmd source [destination] [/options]
echo source - исходный файл или маска файлов
echo destination - результирующий файл или папка (папка должна оканчиваться на обратный слэш)
echo /options - опции:
echo  /x - использовать экстремальное сжатие (более медленная работа)
echo  /m - объединить несколько исходных архивов, заданных маской source, в один архив 7-ZIP
echo       (иначе каждый будет перепакован отдельно); если результирующий архив существует,
echo       он будет сохранён, а файлы из исходных архивов будут добавлены в него^^!
echo  /o - перезаписывать (удалять) результирующий архив, если он существует
echo  /d - удалить исходный архив, но только если архивы идентичны
echo  /dc - удалить исходный архив, даже если не удалось проверить идентичность архивов
echo  /da - удалить исходный архив в любом случае, даже если архивы различны
echo       (при задании нескольких опций /d /dc /da используется последний заданныйж
echo       опции /d, /dc и /da игнорируются, если задана /m)
echo  /ra - снимать атрибуты "только для чтения", "системный" и "скрытый" перед удалением
echo       (см. опции /o и /d), иначе архивы, имеющие данные атрибуты, удаляться не будут
echo  /w - использовать, по возможности, WinRAR вместо 7-zip для распаковки не-rar-архивов
echo       (для rar-архивов всегда используется rar, если он установлен)
echo  /p - не делать пауз после завершения перепаковки, /pp - делать паузы всегда
echo       при отсутствии данной опции пауза делается только при ошибке
echo re7z.cmd /c [/ra] [/p^|/pp] - удалить все ранее созданные временные папки
echo ----------------------------------------------------------------------------------------
echo ERRORLEVEL:
echo 0 - успешное завершение, содержимое архивов идентично (либо задана опция /m, тогда
echo     проверка идентичности архивов не осуществляется, либо задано /c и все папки удалены)
echo 1 - перепаковка произошла, но сравнить архивы не удалось
echo 2 - перепаковка произошла, но содержимое архивов различно
echo 3 - исходный файл не найден
echo 4 - ошибка создания (удаления для /c) временной папки либо она уже существует
echo 5 - ошибка распаковки (временная папка после распаковки не найдена)
echo 6 - ошибка архивации (результирующий файл после архивации не найден)
echo 7 - результирующий архив уже существует
echo 8 - ошибка удаления результирующего архива (при указании опции /o)
echo 10 - архиватор 7-ZIP не найден
echo 20 - указан один и тот же файл
echo 100 - неверно заданы параметры
echo 200 - командный процессор не поддерживает расширенную обработку команд
echo ----------------------------------------------------------------------------------------
pause > nul
exit /b

:nocmdext
echo -----------------------------------------------------------------
echo Командный процессор не поддерживает расширенную обработку команд!
echo -----------------------------------------------------------------
pause > nul
exit /b 200

:nosourcefile
call :ShowMsg "Исходный файл не найден#" 3
exit /b %exitcode%

:badparam
call :ShowMsg "Указан недопустимый параметр (%2)#" 100
exit /b %exitcode%

:samefiles
call :ShowMsg "Указан один и тот же файл исходного и результирующего архивов#" 20
exit /b %exitcode%

:alreadyexist7z
call :ShowMsg "Результирующий архив уже существует#" 7
exit /b %exitcode%

:deldesterror
call :ShowMsg "Ошибка удаления результирующего архива#" 8
exit /b %exitcode%

:no7zapp
call :ShowMsg "Архиватор 7-ZIP не найден#" 10
exit /b %exitcode%

:tempdirerror
call :ShowMsg "Ошибка создания временной папки (либо она уже существует и сделано слишком много попыток подбора другого имени папки), попробуйте ещё раз#" 4
exit /b %exitcode%

:unpackerror
call :ShowMsg "Ошибка распаковки RAR/ZIP#" 5
exit /b %exitcode%

:packerror
call :RemoveTempDir
call :ShowMsg "Ошибка архивации 7-ZIP#" 6
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
