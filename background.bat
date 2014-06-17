@echo off
:main
start /B /wait c:\startup_server\startup.rb > nil
goto :main
