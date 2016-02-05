require 'models/robot_roster'
require 'yaml/store'
require 'models/robot'

class RobotWorldApp < Sinatra::Base
  set :root, File.expand_path("..", __dir__)

  get '/' do
    erb :dashboard
  end

  get '/robots' do
    @robots = []
    10.times do
      @robots << Robot.new
    end
    erb :index
  end

  get '/robots/new' do
    erb :new
  end

  not_found do
   erb :error
  end

  def robot_roster
    database = YAML::Store.new("db/robot_roster")
    RobotRoster.new(database)
  end

end
