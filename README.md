startup_server  
==============  

**Supported browsers**  
 - Available Browsers  
 - Chrome 35  
 - Opera 12, 22  
 - Firefox 30  
 - Safari 7  
  
**Only for For OSX**  
If you want the server to start during boot, place the `com.superuser.startupserver.plist` in `/Library/LaunchDaemons`  
I assume your code path is `/Users/prashanth/start_stop_server/startup.rb` and  
Ruby path is `/usr/local/rvm/rubies/ruby-2.1.2/bin/ruby`  
If not update the plist.  
Run  
`cd /Library/LaunchDaemons`  
`sudo chown -R root:wheel com.superuser.startupserver.plist`  
`sudo launchctl load com.superuser.startupserver.plist`  
  
To verify that this will run during startup,  
`sudo launchctl list | grep startupserver`  
  
To remove the plist from boot,  
`sudo launchctl unload -w /Library/LaunchDaemons/com.superuser.startupserver.plist`  
