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
end
