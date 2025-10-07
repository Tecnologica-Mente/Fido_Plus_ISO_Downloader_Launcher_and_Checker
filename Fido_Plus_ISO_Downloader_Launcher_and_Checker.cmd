@setlocal DisableDelayedExpansion
@echo off


::===========================================================================================================
::
::   This AIO script is a simple Fido - ISO Downloader Launcher of official Windows ISOs
::   (for more details see: https://github.com/pbatard/Fido).
::   The term Plus was added because an additional mechanism has been developed separately
::   that allows you to download the latest Windows 11 or Windows 10 ISO from Microsoft servers.
::   Furthermore, the script allows you to check, once the desired ISO has been downloaded,
::   which edition of Windows it contains.
::
::   Homepage: https://github.com/Tecnologica-Mente
::      Email: <not available>
::
::===========================================================================================================




::========================================================================================================================================
:MainMenu

cls
color 07
title  Fido Plus ISO Downloader Launcher and Checker v1.0.0
mode 120, 30
set "fpidlactemp=%SystemRoot%\Temp\__FPIDLAC"
if exist "%fpidlactemp%\.*" rmdir /s /q "%fpidlactemp%\" %nul%

echo:
echo:
echo:             Welcome to Fido Plus ISO Downloader Launcher and Checker v1.0.0
echo:
echo:       _________________________________________________________________________________________________
echo:
echo:             Please select:
echo:
echo:             [1] To download the Windows 10, Windows 11, or UEFI Shell ISO (choosing the version)
echo:             [2] To download the latest Windows 11 ISO from Microsoft servers (automatic choice)
echo:             [3] To download the latest Windows 10 ISO from Microsoft servers (automatic choice)
echo:             [4] To list the Windows editions that can be installed from the downloaded ISO file
echo:                 (NOTE: You must mount the ISO file first)
echo:             _____________________________________________________________________________________
echo:                                                                     
echo:             [5] Read Me
echo:             [6] Exit
echo:       _________________________________________________________________________________________________
echo:
echo:             Enter a menu option in the Keyboard [1,2,3,4,5,6]:
echo:
choice /C:123456 /N
set _erl=%errorlevel%

if %_erl%==6 exit /b
if %_erl%==5 start https://github.com/Tecnologica-Mente/Fido_Plus_ISO_Downloader_Launcher_and_Checker 	& goto :MainMenu
if %_erl%==4 setlocal & call :ListWinEditions	& cls & endlocal 					& goto :MainMenu
if %_erl%==3 setlocal & call :ISOdownloader10	& cls & endlocal					& goto :MainMenu
if %_erl%==2 setlocal & call :ISOdownloader11	& cls & endlocal					& goto :MainMenu
if %_erl%==1 setlocal & call :ISOdownloader	& cls & endlocal					& goto :MainMenu
goto :MainMenu

::========================================================================================================================================
:ISOdownloader
@setlocal DisableDelayedExpansion
@echo off

set mypath=%cd%
::@echo %mypath%

REM echo Please accept the App's request to make changes to this device...
REM TIMEOUT /T 5
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm https://bit.ly/fidowindows | iex"
echo:
echo Press any key to continue...
pause >nul
popd
exit /b

::========================================================================================================================================
:ISOdownloader11
@setlocal DisableDelayedExpansion
@echo off

set mypath=%cd%
::@echo %mypath%

REM echo Please accept the App's request to make changes to this device...
REM TIMEOUT /T 5
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm https://bit.ly/fidowindows11 | iex"
echo:
echo Press any key to continue...
pause >nul
popd
exit /b

::========================================================================================================================================
:ISOdownloader10
@setlocal DisableDelayedExpansion
@echo off

set mypath=%cd%
::@echo %mypath%

REM echo Please accept the App's request to make changes to this device...
REM TIMEOUT /T 5
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm https://bit.ly/fidowindows10 | iex"
echo:
echo Press any key to continue...
pause >nul
popd
exit /b

::========================================================================================================================================
:ListWinEditions
@setlocal DisableDelayedExpansion
@echo off

:: Adapted from: https://stackhowto.com/batch-file-to-check-if-multiple-files-exist/
set mypath=%cd%
::@echo %mypath%
echo Please mount the ISO file and then enter the drive letter assigned to the file.
set /p char=Enter the drive letter assigned to the ISO file (e.g., D): 

:: First check for the presence of the "install.wim" file
if exist "%char%:\sources\install.wim" (
   echo In a few seconds, a PowerShell window will open.
   echo Right-click in a blank area of ​​this window to paste the command that will list the Windows editions contained in the ISO file, then press Enter.
   TIMEOUT /T 10
   cd /d "%~dp0"
   powershell.exe -Command "Start-Process PowerShell -Verb RunAs -ArgumentList '-NoExit', '-Command', 'cd', '%CD%'"
   echo|set/p="dism /get-wiminfo /wimfile:%char%:\sources\install.wim"|clip
)

:: If the "install.wim" file does not exist, check for the "install.esd" file.
if exist "%char%:\sources\install.esd" (
   echo In a few seconds, a PowerShell window will open.
   echo Right-click in a blank area of ​​this window to paste the command that will list the Windows editions contained in the ISO file, then press Enter.
   TIMEOUT /T 10
   cd /d "%~dp0"
   powershell.exe -Command "Start-Process PowerShell -Verb RunAs -ArgumentList '-NoExit', '-Command', 'cd', '%CD%'"
   echo|set/p="dism /get-wiminfo /wimfile:%char%:\sources\install.esd"|clip
)

:: If neither file exists
echo Cannot find either install.wim or install.esd file. Operation aborted

:continue
echo:
echo Press any key to continue...
pause >nul
popd
exit /b

::========================================================================================================================================
