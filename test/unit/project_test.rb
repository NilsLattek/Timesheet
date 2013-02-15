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
    timesheet.entries.build({ :hours => '2', :description => "Lot's of meetings", :task_id => pm_task.id })
    assert timesheet.save, timesheet.errors.full_messages.join("\n")

    assert_equal 5, project.actual_hours
  end
end
