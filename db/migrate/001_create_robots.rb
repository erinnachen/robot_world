require 'sequel'
databases = ["db/robot_world.sqlite3","db/robot_world_test.sqlite3"]
databases.each do |filename|
  Sequel.sqlite(filename).create_table(:robots) do
    primary_key :id
    String :name, :null=>false
    String :city, :null=>false
    String :state, :null=>false
    String :birthdate, :null=>false
    String :department, :null=>false
    String :date_hired, :null=>false
    String :avatar, :size => 255,:null=>false
  end
end
