ENV['RACK_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'tilt/erb'
require 'capybara/dsl'

module TestHelpers
  def teardown
    robot_roster.delete_all
    super
  end

  def robot_roster
    database = YAML::Store.new('db/robot_roster_test')
    @robot_roster ||= RobotRoster.new(database)
  end

  def create_robots(n = 1, params = nil)
    n.times do |num|
      data = {name: "Jane Robota #{num+1}", birthdate: Time.parse('02/07/2000')}
      params.each do |key, value|
        data[key.to_sym] = value
      end if params
      robot_roster.create(data)
    end
  end

end

Capybara.app = RobotWorldApp
Capybara.save_and_open_page_path = 'tmp/capybara'

class FeatureTest < Minitest::Test
  include Capybara::DSL
  include TestHelpers
end
