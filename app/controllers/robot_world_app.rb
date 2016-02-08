require 'yaml/store'

class RobotWorldApp < Sinatra::Base
  set :root, File.expand_path("..", __dir__)
  set :method_override, true

  get '/' do
    erb :dashboard
  end

  get '/stats' do
    @stats = robot_roster.stats
    erb :stats
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

  get '/robots/:id' do |id|
    @robot = robot_roster.find(id.to_i)
    erb :show
  end

  get "/robots/:id/edit" do |id|
    @robot = robot_roster.find(id.to_i)
    erb :edit
  end

  put '/robots/:id' do |id|
    robot_roster.update(params[:robot], id.to_i)
    redirect "/robots/#{id}"
  end

  delete '/robots/:id' do |id|
    robot_roster.delete(id.to_i)
    redirect '/robots'
  end

  not_found do
   erb :error
  end

  def robot_roster
    if ENV["RACK_ENV"] == "test"
      database = YAML::Store.new("db/robot_roster_test")
    else
      database = YAML::Store.new("db/robot_roster_development")
    end
    @robot_roster ||= RobotRoster.new(database)
  end

end
