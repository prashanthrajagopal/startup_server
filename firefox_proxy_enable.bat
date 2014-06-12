echo off

cd /D "%APPDATA%\Mozilla\Firefox\Profiles"
cd *.default
echo user_pref("network.proxy.http", "127.0.0.1 ");>>"prefs.js"
echo user_pref("network.proxy.http_port", 80);>>"prefs.js"
echo user_pref("network.proxy.type", 1);>>"prefs.js"
