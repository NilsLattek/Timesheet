require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "should calculate the estimated effort based on its tasks" do
    project = projects(:MyProject)
    assert_equal project.estimated_effort, 7.5
  end

  test "should calculate the actual hours based on the timesheet entries" do
    project = Project.create({ :name => 'Testproject' })
    dev_task = project.tasks.create({ :name => 'Development', :estimated_effort => 0 })
    pm_task = project.tasks.create({ :name => 'Projectmanagement', :estimated_effort => 0 })

    timesheet = timesheets(:completeDay)
    timesheet.entries.build({ :hours => '3', :description => 'Worked on feature x', :task_id => dev_task.id })
    timesheet.entries.build({ :hours => '5', :description => "Lot's of meetings", :task_id => pm_task.id })
    assert timesheet.save, timesheet.errors.full_messages.join("\n")

    assert_equal 8, project.actual_hours
  end

  test "should return only active projects" do
    projects = Project.active
    assert_equal 1, projects.length
    assert_equal 'MyProject', projects[0].name
  end

  test "should return the users projects with the aggregated hours" do
    user = users(:user)
    timesheet = timesheets(:employeeTimesheet)
    finishedProject = projects(:FinishedProject)
    finishedProjectTask = tasks(:FinishedProjectTask)

    # create a second timesheet in the same week so that we can test the aggregation
    secondTimesheet = timesheet.dup
    secondTimesheet.entries.build({ :hours => 8, :description => 'Another entry', :task_id => finishedProjectTask.id })
    secondTimesheet.save

    projects = Project.find_for_user_by_week user, timesheet.date
    assert_equal 2, projects.length
    assert_equal 11, projects.select { |p| p.id == finishedProject.id }[0].hours
    assert_equal 5, projects.select { |p| p.id != finishedProject.id }[0].hours
  end
end
