require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    sign_in users(:admin)

    @task = tasks(:TaskDevelopment)
    @project = projects(:MyProject)
  end

  #test "should get index" do
  #  get :index
  #  assert_response :success
  #  assert_not_nil assigns(:tasks)
  #end

  test "should get new" do
    get :new, project_id: @project.id
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, project_id: @project.id, task: { name: @task.name, project_id: @project.id, estimated_effort: 2 }
    end

    assert_redirected_to project_path(@project)
  end

  test "should show task" do
    get :show, id: @task, project_id: @project.id
    assert_response :success

    # should show entries for this task
    assert_select 'table tr', {:count => 2}
  end

  test "should get edit" do
    get :edit, id: @task, project_id: @project.id
    assert_response :success
  end

  test "should update task" do
    put :update, id: @task, project_id: @project.id, task: { name: @task.name }
    assert_redirected_to project_path(@project)
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, id: @task, project_id: @project.id
    end

    assert_redirected_to project_path(@project)
  end
end
