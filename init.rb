require_relative './rserver'

class Server < Sinatra::Application
  s = RServer.new
  get '/' do
    "<u>Available Browsers</u></br>
    Chrome 35</br>
    Opera 12, 22</br>
    Firefox 29</br>
    Safari 7"
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
