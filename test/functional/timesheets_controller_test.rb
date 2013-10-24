require 'test_helper'

class TimesheetsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    sign_in users(:user)

    @timesheet = timesheets(:employeeTimesheet)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:timesheets)
  end

  test "should get new" do
    get :new
    assert_response :success
    # should only show two active projects
    assert_select '#timesheet_entries_attributes_0_task_id optgroup', {:count => 2}
  end

  test "should create timesheet" do
    entry = entries(:completeDay)
    assert_difference('Timesheet.count') do
      post :create, timesheet: {
        date: @timesheet.date,
        end_time: @timesheet.end_time,
        lunch_break: @timesheet.lunch_break,
        start_time: @timesheet.start_time,
        entries_attributes: [{task_id: entry.task_id, hours: entry.hours, description: entry.description}]
      }
    end

    assert_redirected_to timesheet_path(assigns(:timesheet))
  end

  test "should create multiple timesheets" do
    entry = entries(:completeDay)
    assert_difference('Timesheet.count', 3) do
      assert_difference('Entry.count', 3) do
        post :create_multiple, { :start_date => '2013-10-24',
                                 :end_date => '2013-10-28',
                                 :timesheet => {
                                    end_time: @timesheet.end_time,
                                    lunch_break: @timesheet.lunch_break,
                                    start_time: @timesheet.start_time,
                                    entries_attributes: [{task_id: entry.task_id, hours: entry.hours, description: entry.description}]
                                 }
                               }
      end
    end

    assert_redirected_to action: 'weekly', year: 2013, week: 43
  end

  test "should show timesheet" do
    get :show, id: @timesheet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @timesheet
    assert_response :success

    # should only show two active projects
    assert_select '#timesheet_entries_attributes_1_task_id optgroup', {:count => 2}
    # should show the finished project as inline text
    assert_select '.nested-fields > .controls', 'Finished Project - Finished task: 3.0 Fixed some bugs'
  end

  test "should update timesheet" do
    entry = entries(:activeEntry)
    secondEntry = entries(:finishedEntry)
    put :update, id: @timesheet, timesheet: {
      date: @timesheet.date,
      end_time: @timesheet.end_time,
      lunch_break: @timesheet.lunch_break,
      start_time: @timesheet.start_time,
      entries_attributes: [
        {id: entry.id, task_id: entry.task_id, hours: 2, description: 'Description changed'},
        {id: secondEntry.id, task_id: secondEntry.task_id, hours: 6, description: secondEntry.description}
      ]
    }

    assert_redirected_to timesheet_path(assigns(:timesheet))
  end

  test "should destroy timesheet" do
    assert_difference('Timesheet.count', -1) do
      delete :destroy, id: @timesheet
    end

    assert_redirected_to weekly_timesheets_path(@timesheet.date.year, @timesheet.date.cweek)
  end
end
