require 'test_helper'

class TimesheetsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    sign_in users(:admin)

    @timesheet = timesheets(:completeDay)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:timesheets)
  end

  test "should get new" do
    get :new
    assert_response :success
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

  test "should show timesheet" do
    get :show, id: @timesheet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @timesheet
    assert_response :success
  end

  test "should update timesheet" do
    entry = entries(:completeDay)
    put :update, id: @timesheet, timesheet: {
      date: @timesheet.date,
      end_time: @timesheet.end_time,
      lunch_break: @timesheet.lunch_break,
      start_time: @timesheet.start_time,
      entries_attributes: [{task_id: entry.task_id, hours: entry.hours, description: entry.description}]
    }
    assert_redirected_to timesheet_path(assigns(:timesheet))
  end

  test "should destroy timesheet" do
    assert_difference('Timesheet.count', -1) do
      delete :destroy, id: @timesheet
    end

    assert_redirected_to timesheets_path
  end
end
