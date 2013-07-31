require 'test_helper'

class DateHelperTest < ActionView::TestCase
  test "cweeks in month" do
    weeks = cweeks_in_month Date.new(2013, 8, 5)
    assert_equal 5, weeks.count
  end

  test "thursday of week" do
    assert_equal '2013-08-08', thursday_of_week(Date.new(2013, 8, 5)).strftime('%Y-%m-%d')
    assert_equal '2013-08-08', thursday_of_week(Date.new(2013, 8, 6)).strftime('%Y-%m-%d')
    assert_equal '2013-08-08', thursday_of_week(Date.new(2013, 8, 7)).strftime('%Y-%m-%d')
    assert_equal '2013-08-08', thursday_of_week(Date.new(2013, 8, 8)).strftime('%Y-%m-%d')
    assert_equal '2013-08-08', thursday_of_week(Date.new(2013, 8, 9)).strftime('%Y-%m-%d')
    assert_equal '2013-08-08', thursday_of_week(Date.new(2013, 8, 10)).strftime('%Y-%m-%d')
    assert_equal '2013-08-08', thursday_of_week(Date.new(2013, 8, 11)).strftime('%Y-%m-%d')
  end
end
