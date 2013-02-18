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
end
