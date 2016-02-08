require_relative '../test_helper'

class UserCanDeleteARobotTest < FeatureTest
  def test_existing_robot_is_deleted_successfully
    robot_props = {name: "John Smith", city: "New York", state: "NY", birthdate: "04/11/2013", department: "War"}
    robot_roster.create(robot_props)
    visit '/robots'

    assert page.has_content? "John Smith"
    assert page.has_content? "War"
    assert page.has_content? "New York"
    assert page.has_content? "NY"
    assert page.has_content? "Nov 04, 2013"

    click_button 'Delete'

    assert '/robots', current_path
    within '#robots' do
      refute page.has_content? "John Smith"
      refute page.has_content? "War"
      refute page.has_content? "New York"
      refute page.has_content? "NY"
      refute page.has_content? "Nov 04, 2013"
    end
  end
end
