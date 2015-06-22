require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  test "employees can only access their own timesheets" do
    employee = users(:user)
    ability = Ability.new(employee)

    assert !ability.can?(:manage, timesheets(:completeDay))
    assert ability.can?(:manage, timesheets(:employeeTimesheet))
  end

  # test "employees cannot edit timesheets which are older than two weeks" do
  #   employee = users(:user)
  #   ability = Ability.new(employee)
  #
  #   timesheet = Timesheet.create({
  #     :date => 15.days.ago.to_date,
  #     :start_time => Time.now - 2.hours,
  #     :end_time => Time.now + 1.hour,
  #     :lunch_break => 30 })
  #   timesheet.user = employee
  #   timesheet.entries.build({ :hours => 2.5, :description => 'My work', :task_id => '1' })
  #
  #   assert timesheet.valid?
  #   assert !ability.can?(:edit, timesheet)
  #
  #   timesheet.date = 10.days.ago.to_date
  #   assert ability.can?(:edit, timesheet)
  # end
end
