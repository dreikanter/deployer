require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  def test_show
    get dashboard_show_url
    assert_response :success
  end

end
