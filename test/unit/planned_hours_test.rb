require 'test_helper'

class PlannedHourTest < ActiveSupport::TestCase
  test "total_hours_per_week_between" do
    planned_hours = PlannedHour.total_hours_per_week_between(Date.new(2013, 7, 11), Date.new(2013, 7, 25))
    assert_equal 1, planned_hours.length
    assert_equal 15, planned_hours[0].hours
  end
end
