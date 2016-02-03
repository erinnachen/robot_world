class RobotWorldApp < Sinatra::Base
  set :root, File.expand_path("..", __dir__)

  get '/' do
    erb :dashboard
  end

  not_found do
   erb :error
  end

end
