require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "inactive users are not allowed to login" do
    inactive_user = User.new({ :active => false })
    assert !inactive_user.active_for_authentication?
  end
end
