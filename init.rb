require_relative './rserver'

class Server < Sinatra::Application
  s = RServer.new
  get '/' do
    "<u>Available Browsers</u></br>
    Chrome 37</br>
    Opera 12, 22</br>
    Firefox 29</br>
    Safari 5</br>
    Internet Explorer 8"
  end

  get '/start' do
    s.start(params[:browser], params[:version], params[:proxy], params[:url])
  end

  get '/stop' do
    s.stop(params[:browser])
  end

  get '/clean' do
    s.cleanup(params[:browser])
  end
end