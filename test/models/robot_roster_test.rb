require_relative '../test_helper'

class RobotRosterTest < Minitest::Test
  include TestHelpers

  def test_it_can_create_a_robot
    create_robots(1)
    robots = robot_roster.all
    robot = robots.last

    assert_equal 1, robots.length
    assert robot.id
    assert_equal "Jane Robota 1", robot.name
    assert robot.birthdate < Time.now
  end

  def test_can_create_a_random_robot
    robot_roster.create
    robots = robot_roster.all
    robot = robots.last
    assert_equal 1, robots.length

    properties.each do |prop|
      assert robot.robot_props[prop]
    end
    assert_kind_of Time, robot.birthdate
    assert_kind_of Time, robot.date_hired
  end

  def test_all_returns_an_empty_array_if_there_are_no_robots
    assert_equal [], robot_roster.all
  end

  def test_all_returns_robots_in_order
    create_robots(20)
    robots = robot_roster.all
    assert_equal 20, robots.length
    id0 = robots.first.id
    robots.each_with_index do |robot, ind|
      assert_equal id0+ind, robot.id
      assert_equal "Jane Robota #{ind+1}", robot.name
      properties.each do |prop|
        assert robot.robot_props[prop]
      end
      assert_kind_of Time, robot.birthdate
      assert_kind_of Time, robot.date_hired
      assert robot.birthdate < robot.date_hired
    end
  end

  def test_find_can_return_all_robots
    create_robots(5)
    robots = robot_roster.all
    assert_equal 5, robots.length
    id0 = robots.first.id
    5.times do |ind|
      robot = robot_roster.find(id0+ind)
      assert_equal id0+ind, robot.id
      assert_equal "Jane Robota #{ind+1}", robot.name
      properties.each do |prop|
        assert robot.robot_props[prop]
      end
      assert_kind_of Time, robot.birthdate
      assert_kind_of Time, robot.date_hired
      assert robot.birthdate < robot.date_hired
    end
  end

  def test_returns_nil_if_robot_id_does_not_exist
    create_robots(5)
    robots = robot_roster.all
    id0 = robots.last.id
    assert_nil robot_roster.find(id0+30)
  end

  def test_can_delete_a_robot
    create_robots(5)
    robots = robot_roster.all
    id0 = robots.first.id

    robot_roster.delete(id0+3)

    assert_nil robot_roster.find(id0+3)
    refute robot_roster.all.any? {|robot| robot.id == id0+3}
  end

  def test_does_not_change_robots_if_id_not_in_roster
    create_robots(5)
    robots = robot_roster.all
    id0 = robots.first.id

    robot_roster.delete(id0+25)
    robots = robot_roster.all

    robots.each_with_index do |robot, ind|
      assert_equal id0+ind, robot.id
      assert_equal "Jane Robota #{ind+1}", robot.name
      properties.each do |prop|
        assert robot.robot_props[prop]
      end
      assert_kind_of Time, robot.birthdate
      assert_kind_of Time, robot.date_hired
      assert robot.birthdate < robot.date_hired
    end
  end

  def test_update_can_change_properties_of_robots
    create_robots(5)
    robots = robot_roster.all
    id0 = robots.first.id

    robot_roster.update({name: "Hal Robot", city: "Denver", state: "CO", birthdate: "04/10/2014", department: "Recreation"}, id0+3)

    updated = robot_roster.find(id0+3)

    assert_equal id0+3, updated.id
    assert_equal "Hal Robot", updated.name
    assert_equal "Denver", updated.city
    assert_equal "CO", updated.state
    assert_equal "Recreation", updated.department
    assert_equal Time.parse("04/10/2014"), updated.birthdate
    assert updated.birthdate < updated.date_hired

    assert_equal id0, robot_roster.all.first.id
    assert_equal id0+4, robot_roster.all.last.id
  end

  def test_does_not_change_robots_if_id_not_in_roster
    create_robots(5)
    robots = robot_roster.all
    id0 = robots.first.id

    robot_roster.update({name: "Hal Robot", city: "Denver", state: "CO", birthdate: "04/10/2014", department: "Recreation"},id0+25)
    robots = robot_roster.all
    robots.each_with_index do |robot, ind|
      assert_equal id0+ind, robot.id
      assert_equal "Jane Robota #{ind+1}", robot.name
      properties.each do |prop|
        assert robot.robot_props[prop]
      end
      assert_equal Time.parse('02/07/2000'), robot.birthdate
      assert_kind_of Time, robot.date_hired
      assert robot.birthdate < robot.date_hired
    end
  end

  def test_can_return_number_of_robots_correctly_no_robots
    assert_equal 0, robot_roster.stats[:num]
  end

  def test_can_return_number_of_robots_correctly
    create_robots(6)
    assert_equal 6, robot_roster.stats[:num]
  end

  def test_stats_years_returns_empty_array_if_no_robots
    assert_equal [], robot_roster.stats[:hires]
  end

  def test_stats_hires_returns_correct_count_of_robots
    3.times do |num|
      robot_roster.create({name: "Jane Smith #{num+1}", birthdate: Time.parse('25/01/2000'), date_hired: Time.parse('02/07/2010')})
    end
    2.times do |num|
      robot_roster.create({name: "Jane Robota #{num+1}", birthdate: Time.parse('25/01/1997'), date_hired: Time.parse('02/07/2003')})
    end
    assert_equal [[2010, 3], [2003, 2]], robot_roster.stats[:hires]
  end

  def test_average_age_returns_zero_if_no_robots
    assert_equal 0, robot_roster.stats[:avg_age]
  end

  def test_stats_average_returns_correct_time_of_hire_of_robots
    ref_date = Time.parse('02/07/2010')
    robot_roster.create({name: "Jane Smith", birthdate: ref_date - 45})
    robot_roster.create({name: "Jane Robota", birthdate: ref_date - 33})
    robot_roster.create({name: "Reginald Robot", birthdate: ref_date - 22})
    assert_equal 33.33, robot_roster.stats(ref_date)[:avg_age]
  end

  def properties
    [:name, :city, :state, :avatar, :birthdate, :date_hired, :department, :id]
  end

end
