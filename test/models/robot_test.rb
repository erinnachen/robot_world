require_relative '../test_helper'

class RobotTest< Minitest::Test
  def test_assigns_attributes_correctly
    robot = helper_robot
    assert_equal "John Smith", robot.robot_props[:name]
    assert_equal "New York", robot.robot_props[:city]
    assert_equal "NY", robot.robot_props[:state]
    assert_equal Time.parse("04/11/2013"), robot.robot_props[:birthdate]
    assert_equal "War", robot.robot_props[:department]
  end

  def test_can_create_a_random_robot
    robot = Robot.new
    assert_kind_of Robot, robot
    properties.each do |prop|
      assert robot.robot_props[prop]
    end
    assert_kind_of Time, robot.birthdate
    assert_kind_of Time, robot.date_hired
  end

  def test_birthdate_is_before_date_hired
    robot = helper_robot
    assert robot.birthdate < robot.date_hired

    robot = Robot.new
    assert robot.birthdate < robot.date_hired
  end

  def test_must_have_a_birthdate_before_today
    robot = helper_robot({birthdate: (Time.now+10000)})
    assert robot.birthdate < Time.now
  end

  def test_can_still_create_a_robot_with_invalid_input
    robot = helper_robot({birthdate: "Not actually a date"})
    assert_kind_of Time, robot.birthdate
  end

  def properties
    [:name, :city, :state, :avatar, :birthdate, :date_hired, :department, :id]
  end

  def helper_robot(properties = {})

    data = {name: "John Smith", city: "New York", state: "NY", birthdate: "04/11/2013", department: "War"}
    properties.each do |key, value|
      data[key] = value
    end
    Robot.new(data)
  end
end
