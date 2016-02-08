require_relative '../test_helper'

class UserCanCreateNavigateTest < FeatureTest
  def test_navigate_from_all_pages_with_navbar
    paths = ['/robots', '/robots/new', '/stats']
    paths.each do |path|
      visit path
      click_link "(little) Robot World"
      assert_equal '/', current_path

      visit path
      click_link "All the Robots"
      assert_equal '/robots', current_path

      visit path
      click_link "World statistics"
      assert_equal '/stats', current_path

    end
  end
end
