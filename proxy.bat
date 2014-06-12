echo off
if "%1" == "enable" (
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" ^ /v ProxyEnable /t REG_DWORD /d 1 /f
) else if "%1" == "disable" (
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" ^ /v ProxyEnable /t REG_DWORD /d 0 /f
) else (
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" ^ /v ProxyServer /t REG_SZ /d 127.0.0.1:80 /f
)
