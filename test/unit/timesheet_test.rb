require 'test_helper'

class TimesheetTest < ActiveSupport::TestCase
  test "should not save without all required fields" do
    timesheet = Timesheet.new
    assert !timesheet.save, "Saved the post without required fields"

    timesheet.lunch_break = 30
    assert !timesheet.save

    entry = entries(:completeDay)
    timesheet.entries = [entry]

    timesheet.date = Date.new
    assert !timesheet.save

    timesheet.start_time = Time.new(2012, 1, 17, 8, 0)
    assert !timesheet.save

    timesheet.end_time = Time.new(2012, 1, 17, 16, 30)
    assert timesheet.save
  end

  test "should not save when end time is before start time" do
    timesheet = Timesheet.new({date: Date.new, lunch_break: 30})
    timesheet.start_time = Time.new(2012, 01, 17, 9, 0, 0)
    timesheet.end_time = Time.new(2012, 01, 17, 8, 0, 0)
    assert !timesheet.save
    assert_equal 1, timesheet.errors[:endTime].length
  end

  test "should return the difference between start time and end time" do
    timesheet = timesheets(:two)
    assert_equal 7.5, timesheet.hours_worked
  end

  test "should return 0 if no time is provided" do
    timesheet = Timesheet.new
    assert_equal 0, timesheet.hours_worked
  end

  test "should round hours_worked" do
    timesheet = Timesheet.new({ date: Date.new, lunch_break: 0})
    timesheet.start_time = Time.new(2012, 01, 17, 17, 4, 0)
    timesheet.end_time = Time.new(2012, 01, 17, 20, 18, 0)
    assert_equal 3.23, timesheet.hours_worked
  end

  test "should not save when there are not enough entry hours" do
    timesheet = timesheets(:one)
    entry = entries(:completeDay)

    timesheet.entries = [entry]
    assert !timesheet.save
    assert_equal 1, timesheet.errors[:entries].length
  end

  test "should save when there are enough entry hours" do
    timesheet = timesheets(:completeDay)
    entry = entries(:completeDay)

    timesheet.entries = [entry]
    assert timesheet.save
  end

  test "should not save when hours worked is negative" do
    timesheet = Timesheet.new({date: Date.new, lunch_break: 30})
    timesheet.start_time = Time.new(2012, 01, 18, 10, 0, 0);
    timesheet.end_time = Time.new(2012, 01, 18, 10, 1, 0);

    assert !timesheet.save
    assert_equal 1, timesheet.errors[:hours_worked].length
  end

  test "should not save with empty string values" do
    timesheet = Timesheet.new
    timesheet.date = ''
    timesheet.start_time = ''
    timesheet.end_time = ''
    timesheet.lunch_break = ''
    timesheet.entries.build({ :hours => '', :description => '', :task_id => '1'})

    assert !timesheet.save
  end

  test "should not save when there is no lunch break" do
    timesheet = Timesheet.new({
      :date => Date.new,
      :start_time => Time.new(2012, 01, 17, 9, 0, 0),
      :end_time => Time.new(2012, 01, 17, 17, 0, 0),
      :lunch_break => '' })

    timesheet.entries.build({ :hours => 8, :description => 'My work', :task_id => '1'})

    assert !timesheet.save
    assert_equal 1, timesheet.errors[:lunch_break].length
  end

  test "should allow removing of an entry" do
    timesheet = timesheets(:employeeTimesheet)
    timesheet.entries[0].hours = 8
    timesheet.entries[1].mark_for_destruction

    assert_difference 'Entry.count', -1 do
      assert timesheet.save
    end
  end
end
