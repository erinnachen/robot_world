require_relative '../test_helper'

class UserCanCreateNewRobots < FeatureTest
  def test_create_a_random_robot
    visit '/robots/new'
    click_button 'build me a random robot'

    assert_equal '/robots', current_path

    robot = robot_roster.all.first
    within ".robot-#{robot.id}" do
      assert page.has_content? "#{robot.name}"
      assert page.has_content? "#{robot.department}"
    end
  end

  def test_create_a_robot
    visit '/robots/new'

    fill_in 'robot[name]', with: 'Warren Johnson'
    fill_in 'robot[birthdate]', with: '03/04/2007'
    fill_in 'robot[city]', with: 'Santa Monica'
    fill_in 'robot[state]', with: 'CA'
    select "Data Collection", from: "robot_dept"

    click_button "beep beep beep"

    assert_equal '/robots', current_path

    robot = robot_roster.all.first
    within ".robot-#{robot.id}" do
      assert page.has_content? "Warren Johnson"
      assert page.has_content? "Data Collection"
      assert page.has_content? "Santa Monica"
      assert page.has_content? "CA"
      assert page.has_content? "#{Time.parse('03/04/2007').strftime("%b %d, %Y")}"
    end
  end
end
