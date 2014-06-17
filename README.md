startup_server
==============

ALl of the commands below need to be run from an administrative cmd window as we will be modifying registry keys  
**Setup**  
Install ruby from http://rubyinstaller.org  
`gem install sinatra thin win32-process`  

**Startup**  
`cd startup_server`  
`rackup`  

**Start the Sinatra server in the background**  
Assuming the code resides at c:\startup_server\  
`cd startup_server`  
`background.bat`  

