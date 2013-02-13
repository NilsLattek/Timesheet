require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should set default value for estimated effort to 0" do
    task = Task.new
    assert !task.valid?

    task.name = "Test task"
    assert !task.valid?

    task.estimated_effort = 1
    assert task.valid?
  end
end
