require 'rubygems'
require 'win32/service'

include Win32

SERVICE_NAME = 'ruby_startup_service'

Service.create({
  :service_name       => SERVICE_NAME,
  :service_type       => Service::WIN32_OWN_PROCESS,
  :description        => 'A sinatra service that starts and stops browsers on port 9090',
  :start_type         => Service::AUTO_START,
  :error_control      => Service::ERROR_NORMAL,
  :binary_path_name   => 'c:\Ruby\bin\ruby.exe -C c:\Users\test\Desktop\server ruby_startup_service.rb',
  :load_order_group   => 'Network',
  :dependencies       => ['W32Time','Schedule'],
  :display_name       => SERVICE_NAME
})

#Service.delete(SERVICE_NAME)
