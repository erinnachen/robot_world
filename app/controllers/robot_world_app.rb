require 'models/robot_roster'
require 'yaml/store'
require 'models/robot'

class RobotWorldApp < Sinatra::Base
  set :root, File.expand_path("..", __dir__)

  get '/' do
    erb :dashboard
  end

  get '/robots' do
    @robots = robot_roster.all
    erb :index
  end

  get '/robots/new' do
    erb :new
  end

  post '/robots' do
    robot_roster.create(params[:robot])
    redirect '/robots'
  end

  post '/robots/random' do
    robot_roster.create()
    redirect '/robots'
  end

  not_found do
   erb :error
  end

  def robot_roster
    database = YAML::Store.new("db/robot_roster")
    RobotRoster.new(database)
  end

end
