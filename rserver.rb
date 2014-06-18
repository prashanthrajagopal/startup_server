require 'yaml'
require 'pry'

class RServer
  def initialize
    $system_proxy = false
    puts "Server Initialized"
    @@conf = YAML.load_file('./config.yml')
  end

  def start(browser, version, proxy = "false", url = "")
    system_wide_proxy if(proxy == "true")
    app = @@conf["browser_list"]["#{browser.downcase}_#{version}"]

    # Kernel.fork("open -n #{app} --args #{url}")
    `open -n #{app} --args #{url}`

    "Opened #{browser}, #{version}"
  end

  def stop(browser)
    task_list = `ps aux | grep -i #{browser} | grep -v grep`.chomp
    if task_list.split[1] != ""
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
    system_wide_proxy("disable") if($system_proxy)
    c_browser = @@conf["clean_list"]["#{browser}"]
    c_browser.each do |d_path|
      d_path.gsub!("whoami",`whoami`.chomp)
      `rm -rf #{d_path}/*`
    end
    "Cleaned data for #{browser}"
  end

  def kill_pid(pid)
    `kill -15 #{pid}`
    sleep(1)
    `kill -9 #{pid}` if(`ps aux | grep #{pid} | grep -v grep`.chomp != "")
  end

  def system_wide_proxy(action = "enable")
    if action == "enable"
      $system_proxy = true
    end
  end
end
