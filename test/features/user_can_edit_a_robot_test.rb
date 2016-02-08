require_relative '../test_helper'

class UserCanEditAnExistingRobotTest < FeatureTest
  def test_existing_robot_can_have_properties_changed
    robot_roster.create({name: "Jenna Warren", city: "Chicago", state: "IL", birthdate: "04/11/2013", department: "Recreation"})

    id = robot_roster.all.last.id

    visit "/robots/#{id}/edit"

    fill_in 'robot[name]', with: 'Warren Johnson'
    fill_in 'robot[birthdate]', with: '03/04/2007'
    fill_in 'robot[city]', with: 'Santa Monica'
    fill_in 'robot[state]', with: 'CA'
    select "Data Collection", from: "robot_dept"

    click_button "Update me"

    assert_equal "/robots/#{id}", current_path
    within("#show-robot-#{id}") do
      assert page.has_content?("Warren Johnson")
      assert page.has_content?("Santa Monica")
      assert page.has_content?("CA")
      assert page.has_content?("Data Collection")
      assert page.has_content?("Apr 03, 2007")

      refute page.has_content?("Jenna Warren")
      refute page.has_content?("Chicago")
      refute page.has_content?("IL")
      refute page.has_content?("Recreation")
      refute page.has_content?("Nov 04, 2013")
    end
  end

  def test_existing_robot_does_not_have_to_have_all_fields_changed
    robot_roster.create({name: "Jenna Warren", city: "Chicago", state: "IL", birthdate: "04/11/2013", department: "Recreation"})

    id = robot_roster.all.last.id

    visit "/robots/#{id}/edit"

    fill_in 'robot[name]', with: 'Warren Johnson'
    select "Data Collection", from: "robot_dept"

    click_button "Update me"

    assert_equal "/robots/#{id}", current_path
    
    within("#show-robot-#{id}") do
      assert page.has_content?("Warren Johnson")
      assert page.has_content?("Chicago")
      assert page.has_content?("IL")
      assert page.has_content?("Data Collection")
      assert page.has_content?("Nov 04, 2013")

      refute page.has_content?("Jenna Warren")
      refute page.has_content?("Recreation")
    end
  end
end
