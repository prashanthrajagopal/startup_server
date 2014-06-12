require 'win32/process'

class RServer
  $system_proxy = false
  $firefox_proxy = false

  def initialize
    puts "Server Initialized"
  end

  def start(browser, version, proxy = "", url = "http://www.google.com")
    STDERR.puts "#{Time.now} - Opening #{browser}, Version: #{version}, proxy: #{proxy}"
    param = url
    b_list = {
      "chrome_37" => "C:\\Program Files\\Google\\Chrome\\Application\\37.0.2041.4\\chrome.exe",
      "safari_5" => "C:\\Program Files\\Safari\\Safari.exe",
      "firefox_29" => "C:\\Program Files\\Mozilla Firefox\\firefox.exe",
      "ie_8" => "C:\\Program Files\\Internet Explorer\\iexplore.exe",
      "opera_22" => "C:\\Program Files\\Opera22\\launcher.exe",
      "opera_12" => "C:\\Program Files\\Opera12\\opera.exe"
    }

    if proxy == "true"
      if((browser == "opera" && version == "12") || browser == "ie" )
        system_wide_proxy("enable")
        system_wide_proxy
        $system_proxy = true
      elsif(browser == "chrome" || browser == "safari" || (browser == "opera" && version == "22"))
        param += " --proxy-server=127.0.0.1:80"
      elsif(browser == "firefox")
        firefox_proxy_enable
        $firefox_proxy = true
      end
    end

    process = b_list[browser.downcase + "_" + version]
    info = Process.create(
      :command_line     => "#{process} #{param}",
      :creation_flags   => Process::DETACHED_PROCESS,
      :process_inherit  => false,
      :thread_inherit   => true,
      :cwd              => "C:\\"
      )

    # Thread.new { `\"#{process}\" #{param}` }
    "Opened #{browser}, #{version} with pid: #{info.process_id}"
  end

  def stop(browser)
    browser = "iexplore" if browser == "ie"
    if pid = `tasklist | findstr #{browser}`.split[1]
      STDERR.puts "#{Time.now} - Stopping PID: #{pid}, browser: #{browser}"
      begin
        `taskkill /PID #{pid}`
      rescue
        STDERR.puts "#{Time.now} - FORCE KILLING PID: #{pid}, browser: #{browser}"
        `taskkill /PID #{pid} /F`
      end
      "#{browser} stopped"
    else
      "#{browser} not running or check the spelling"
    end
  end

  def cleanup(browser)
    firefox_proxy_disable if(browser == "firefox" && $firefox_proxy)
    if ($system_proxy && ((browser == "opera" && version == "12") || browser == "ie" ))
      system_wide_proxy("disable")
    end
    clean_list = {
      "chrome" => "%USERPROFILE%\\AppData\\Local\\Google\\Chrome\\User",
      "safari" => "%USERPROFILE%\\AppData\\Local\\Apple",
      "firefox" => "%USERPROFILE%\\AppData\\Local\\Mozilla\\Firefox",
      "ie" => ["%APPDATA%\\Microsoft\\Internet",
              "%USERPROFILE%\\AppData\\Local\\Microsoft\\Windows\\History",
              "%USERPROFILE%\\AppData\\Roaming\\Microsoft\\Windows\\Cookies",
              "%USERPROFILE%\\AppData\\Local\\Microsoft\\Windows\\Temporary"],
      "opera" => "%USERPROFILE%\\AppData\\Local\\Opera\\Opera",
    }

    c_browser = clean_list[browser]
    if(browser == "ie")
      `reg delete \"HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\" /f`
      c_browser.each do |dir|
        STDERR.puts `for /d %a in (#{dir}*) do rmdir /s /q "%a"`
      end
    else
      STDERR.puts `for /d %a in (#{c_browser}*) do rmdir /s /q "%a"`
    end
    "Cleaned data for #{browser}"
  end

  def system_wide_proxy(action="")
    `proxy.bat #{action}`
  end

  def firefox_proxy_enable
    `firefox_proxy_enable.bat`
  end

  def firefox_proxy_disable
    `firefox_proxy_disable.bat`
  end
end
