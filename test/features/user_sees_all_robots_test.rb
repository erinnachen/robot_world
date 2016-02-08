require_relative '../test_helper'

class UserSeesAllRobotsTest < FeatureTest
  def test_user_sees_all_robots
    create_robots(4)
    visit '/'
    click_link("See pre-existing robots")
    assert_equal '/robots', current_path

    robots = robot_roster.all
    robots.each do |robot|
      within(".robot-#{robot.id}") do
        assert page.has_content?("#{robot.name}")
        assert page.has_content?("#{robot.birthdate.strftime("%b %d, %Y")}")
      end
    end
  end

  def test_user_can_click_on_a_robot
    create_robots(4)
    visit '/robots'

    robot = robot_roster.all[2]
    click_link("robot-image-#{robot.id}")
    within("#show-robot-#{robot.id}") do
      assert page.has_content?("Jane Robota 3")
      assert page.has_content?("#{robot.city}")
      assert page.has_content?("#{robot.state}")
      assert page.has_content?("#{robot.department}")
      assert page.has_content?("#{robot.birthdate.strftime("%b %d, %Y")}")
      assert page.has_content?("#{robot.date_hired.strftime("%b %d, %Y")}")
    end
  end
end
