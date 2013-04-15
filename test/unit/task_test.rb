require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test "should set default value for estimated effort to 0" do
    task = Task.new
    assert !task.valid?

    task.name = "Test task"
    assert !task.valid?

    task.estimated_effort = 1
    assert task.valid?
  end

  test "should calculate the actual hours for this task" do
    task = tasks(:TaskDevelopment)
    assert_equal 13, task.actual_hours
  end

  test "estimated effort cannot be negative" do
    task = tasks(:TaskDevelopment)
    task.estimated_effort = -1
    assert !task.valid?
  end
end
