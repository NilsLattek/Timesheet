require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  test "delete assigned planned hours on delete" do
    assignment = assignments(:user_myproject)
    assert_difference('PlannedHour.count', -2) do
      assignment.destroy
    end
  end
end
