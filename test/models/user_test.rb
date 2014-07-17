require 'test_helper'

class UserTest < ActiveSupport::TestCase
  include DateHelper

  test "inactive users are not allowed to login" do
    inactive_user = User.new({ :active => false })
    assert !inactive_user.active_for_authentication?
  end

  test "prevent removal of project-user association when there are already entries assigned to it" do
    user = users(:user)
    project = projects(:MyProject)

    assert_raises(RuntimeError) {
      user.projects.delete(project)
    }
  end

  test "planned_hours_by_project_in_week" do
    user = users(:user)
    phs = user.planned_hours_by_project_in_week Date.new(2013, 07, 18)
    assert_equal 2, phs.length

    assert_equal "AnotherProject", phs[0].name
    assert_equal 5, phs[0].hours

    assert_equal "MyProject", phs[1].name
    assert_equal 10, phs[1].hours
  end

  test "load all developers" do
    developers = User.developer
    assert_equal 1, developers.length
  end

  test "actual_hours_by_project_in_week" do
    user = users(:user)
    ahs = user.actual_hours_by_project_in_week(thursday_of_week(5.days.ago.to_date))
    assert_equal 2, ahs.length

    project1 = projects(:FinishedProject)
    project2 = projects(:MyProject)

    p1_index = ahs.index { |ah| ah.project_id == project1.id }
    p2_index = ahs.index { |ah| ah.project_id == project2.id }

    assert_not_nil p1_index
    assert_not_nil p2_index

    assert_equal 3, ahs[p1_index].hours
    assert_equal 5, ahs[p2_index].hours
  end
end
