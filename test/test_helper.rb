ENV['RACK_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'tilt/erb'

module TestHelpers
  def teardown
    robot_roster.delete_all
    super
  end

  def robot_roster
    database = YAML::Store.new('db/robot_roster_test')
    @robot_roster ||= RobotRoster.new(database)
  end
end
