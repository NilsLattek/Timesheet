require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  test "should allow editing if the referenced project is not finished"  do
    task = tasks(:TaskDevelopment)
    entry = Entry.new
    entry.task = task
    assert entry.editable?
  end

  test "should not allow editing if the referenced project is finished"  do
    task = tasks(:FinishedProjectTask)
    entry = Entry.new
    entry.task = task
    assert !entry.editable?
  end

  test "should not allow negative hours" do
    entry = entries(:activeEntry)
    entry.hours = -4
    assert !entry.valid?

    entry.hours = 0
    assert entry.valid?
  end

  test "should return all entry hours per week" do
    user = users(:user)
    timesheet = timesheets(:employeeTimesheet)
    finishedProjectTask = tasks(:FinishedProjectTask)

    # create a second timesheet in another week
    secondTimesheet = timesheet.dup
    secondTimesheet.date -= 7
    secondTimesheet.end_time = secondTimesheet.end_time.change({ :hour => 15 })
    secondTimesheet.entries.build({ :hours => 6, :description => 'Another entry', :task_id => finishedProjectTask.id })
    secondTimesheet.save!

    entries = Entry.hours_per_week_for_user(user).order('WEEK(date) DESC')
    assert_equal 2, entries.length
    assert_equal 8, entries[0].hours
    assert_equal timesheet.date.cweek, entries[0].week

    assert_equal 6, entries[1].hours
    assert_equal secondTimesheet.date.cweek, entries[1].week
  end
end
