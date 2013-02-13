require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should calculate the estimated effort based on its tasks" do
    project = projects(:MyProject)
    assert_equal project.estimated_effort, 7.5
  end
end
