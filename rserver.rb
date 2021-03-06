require 'win32/process'
require 'yaml'

class RServer
  $system_proxy = false
  def initialize
    puts "Server Initialized"
    @@conf = YAML.load_file('./config.yml')
    @@proxy = @@conf["proxy"]
  end

  def start(browser, version, proxy = "", url = "http://www.google.com")
    param = url
    if proxy == "true"
      system_wide_proxy
      $system_proxy = true
    end

    process = @@conf["browser_list"]["#{browser.downcase}_#{version}"]

    info = Process.create(
      :command_line     => "#{process} #{param}",
      :creation_flags   => Process::DETACHED_PROCESS,
      :process_inherit  => false,
      :thread_inherit   => true,
      :cwd              => "C:\\"
      )

    "Opened #{browser}, #{version} with pid: #{info.process_id}"
  end

  def stop(browser)
    browser = "iexplore" if browser == "ie"
    task_list = `tasklist | findstr #{browser}`
    if task_list.split[1] == ""
      if task_list.split("\n").length == 1
        kill_pid(task_list.split[1])
      else
        task_list.split("\n").each do |task|
          kill_pid(task.split[1])
        end
      end
    else
      "#{browser} not running or check the spelling"
    end
  end

  def cleanup(browser)
    if ($system_proxy)
      system_wide_proxy("disable")
    end
    clean_list = {
      "chrome" => "%USERPROFILE%\\AppData\\Local\\Google\\Chrome\\User Data",
      "safari" => "%USERPROFILE%\\AppData\\Local\\Appl*",
      "firefox" => "%USERPROFILE%\\AppData\\Local\\Mozilla\\Firefox",
      "ie" => "%APPDATA%\\Microsoft\\Internet",
      "opera" => "%USERPROFILE%\\AppData\\Local\\Opera\\Opera12",
    }

    c_browser = @@conf["clean_list"]["#{browser}"]
    c_browser.each do |d_path|
      if browser == "ie"
        `#{c_browser}`
      else
        `for /d %a in (#{c_browser}*) do rmdir /s /q "%a"`
      end
    end

    "Cleaned data for #{browser}"
  end

  def kill_pid(pid)
    if `taskkill /PID #{pid} 2>&1`.chomp.include?("ERROR") || `taskkill /PID #{pid} 2>&1`.chomp.include?("used by another process")
      "#{browser} stopped"
    else
      "Force Killed #{browser}"
      `taskkill /PID #{pid} /F`
    end
  end

  def system_wide_proxy(action = "enable")
    if action == "enable"
      `reg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\" ^ /v ProxyEnable /t REG_DWORD /d 1 /f`
      `reg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\" ^ /v ProxyServer /t REG_SZ /d #{@@proxy} /f`
    elsif action == "disable"
      `reg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\" ^ /v ProxyEnable /t REG_DWORD /d 0 /f`
    end
  end
end
