require_relative '../test_helper'

class UserCanGetStatsTest < FeatureTest
  def test_user_can_get_correct_statistics
    ref_date = Time.parse('02/07/2010')
    robot_roster.create({name: "Jane Smith", birthdate: ref_date - 45, date_hired: Time.parse('02/07/2014')})
    robot_roster.create({name: "Arnold Wakefield", birthdate: ref_date - 33, date_hired: Time.parse('03/01/2014')})
    robot_roster.create({name: "Reginald Robot", birthdate: ref_date - 22, date_hired: Time.parse('29/09/2015')})

    visit '/stats?date=02/07/2010'
    
    within '#stats-rob-num' do
      assert page.has_content? "3"
    end
    within "#stats-hire-2014" do
      assert page.has_content? "2"
    end
    within "#stats-hire-2015" do
      assert page.has_content? "1"
    end
    within '#stats-avg-age' do
      assert page.has_content? "33.33"
    end

  end
end
