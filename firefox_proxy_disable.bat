cd /D "%APPDATA%\Mozilla\Firefox\Profiles"
cd *.default
set ffile=%cd%
type "%ffile%\prefs.js" | findstr /v "user_pref("network.proxy.type", 1);" >"%ffile%\prefs_.js"
rename "%ffile%\prefs.js" "prefs__.js"
rename "%ffile%\prefs_.js" "prefs.js"
del "%ffile%\prefs__.js"
set ffile=
cd %windir%