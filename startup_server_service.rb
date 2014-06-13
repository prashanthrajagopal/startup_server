LOG_FILE = 'C:\\service.log'

require 'sinatra'

require_relative '.\\init'

begin
  require 'win32/daemon'
  include Win32

  class DemoDaemon < Daemon
    def service_main
      Server.run! :host => 'localhost', :port => 9090, :server => 'thin'
      while running?
        sleep 10
        File.open(LOG_FILE, "a"){ |f| f.puts "Service is running #{Time.now}" }
      end
    end

    def service_stop
      File.open(LOG_FILE, "a"){ |f| f.puts "***Service stopped #{Time.now}" }
      exit!
    end
  end

  DemoDaemon.mainloop
rescue Exception => err
  File.open(LOG_FILE,'a+'){ |f| f.puts " ***Daemon failure #{Time.now} err=#{err} " }
  raise
end
