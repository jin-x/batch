::::::::::::::::::::::::::
:: Settings for DCC.CMD ::
::::::::::::::::::::::::::

:: Strings that contains caret (^) char should be enclosed in quotes (") with variable name (after 'set' command), e.g.:
:: set "defdelphiideexe=bds^.exe"

:: Don't use quotes in paths and filenames (event when spaces are present) like this:
:: set defdelphiideexe="bds.exe"
:: set defdelphiideexe="bds^.exe"

:: Default version and bits
set defversion=102
set defbits=32

:: Delphi main paths
set delphipath6=%ProgramFiles(x86)%\Borland\Delphi6
set delphipath7=%ProgramFiles(x86)%\Borland\Delphi7
set delphipath2005=%ProgramFiles(x86)%\Borland\Delphi2005
set delphipath2006=%ProgramFiles(x86)%\Borland\Delphi2006
set delphipath2007=%ProgramFiles(x86)%\CodeGear\RAD Studio\5.0
set delphipath2009=%ProgramFiles(x86)%\CodeGear\Delphi2009
set delphipath2010=%ProgramFiles(x86)%\Embarcadero\Delphi2010
set delphipathXE=%ProgramFiles(x86)%\Embarcadero\DelphiXE
set delphipathXE2=%ProgramFiles(x86)%\Embarcadero\DelphiXE2
set delphipathXE3=%ProgramFiles(x86)%\Embarcadero\DelphiXE3
set delphipathXE4=%ProgramFiles(x86)%\Embarcadero\DelphiXE4
set delphipathXE5=%ProgramFiles(x86)%\Embarcadero\DelphiXE5
set delphipathXE6=%ProgramFiles(x86)%\Embarcadero\DelphiXE6
set delphipathXE7=%ProgramFiles(x86)%\Embarcadero\DelphiXE7
set delphipathXE8=%ProgramFiles(x86)%\Embarcadero\DelphiXE8
set delphipath10=%ProgramFiles(x86)%\Embarcadero\Delphi10_Seattle
set delphipath101=%ProgramFiles(x86)%\Embarcadero\Studio\18.0
set delphipath102=%ProgramFiles(x86)%\Embarcadero\Studio\19.0

:: Delphi compiler executable filename
set defdelphiexe_32=bin\dcc32.exe
set defdelphiexe_64=bin\dcc64.exe

:: Delphi IDE executable filename
set defdelphiideexe=bin\bds.exe
set delphiideexe6=bin\delphi32.exe
set delphiideexe7=bin\delphi32.exe
set delphiideexe2007=@@-call "%batpath%bds2007.cmd"

:: Delphi names (if name != version or if name contains letters)
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

:: Delphi default options for compiler
set defdelphiopt_32=
set defdelphiopt_64=
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

:: Delphi default options for IDE
set defdelphiideopt=-pDelphi
set delphiideopt6=-
set delphiideopt7=-

:: Delphi additional common options (for compiler and IDE)
set extradelphiopt=
set extradelphiideopt=

:: Delphi version aliases
set delphiveralias_05=2005
set delphiveralias_06=2006
set delphiveralias_07=2007
set delphiveralias_09=2009
set delphiveralias_010=2010
set delphiveralias_X2=XE2
set delphiveralias_X3=XE3
set delphiveralias_X4=XE4
set delphiveralias_X5=XE5
set delphiveralias_X6=XE6
set delphiveralias_X7=XE7
set delphiveralias_X8=XE8
set delphiveralias_100=10
set delphiveralias_Seattle=10
set delphiveralias_Berlin=101
set delphiveralias_Tokyo=102

:: Additional batch options
set dcoptions=%dcoptions%
