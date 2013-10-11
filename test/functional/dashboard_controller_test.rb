require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    sign_in users(:user)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
