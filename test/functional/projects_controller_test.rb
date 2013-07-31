require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    sign_in users(:admin)

    @project = projects(:MyProject)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, project: { name: @project.name }
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should show project" do
    get :show, id: @project
    assert_response :success

    # confirm that the project detail page shows the projects entries
    assert_select 'table tbody tr', {:count => 2}

    project = assigns(:project)
    task = project.tasks.first
    # first row and first column should include the name to the first task
    assert_select 'table tr:first-child td:first-child', task.name
  end

  test "should get edit" do
    get :edit, id: @project
    assert_response :success
  end

  test "should update project" do
    put :update, id: @project, project: { name: @project.name }
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end

  test "should load planned hours" do
    get :planning, month: '2013-07', id: projects(:MyProject).id
    user = users(:user)
    assert_select "input[name='project[planned_hours][#{user.id}][29]'][value=?]", 10.0
    assert_select "span[name='project[planned_hours][#{user.id}][29]_utilization']" do
      assert_select "[data-planned-hours=?]", 15.0
    end
  end

  test "should save planned hours" do
    user = users(:user)
    assert_difference('PlannedHour.count', 2) do
      post :save_planning, id: @project, month: '2013-08', project: { planned_hours: { user.id.to_s => {"31" => "1", "32" => "2", "33" => "0"}} }
    end
  end

  test "should delete 0-hours" do
    user = users(:user)
    post :save_planning, id: @project, month: '2013-08', project: { planned_hours: { user.id.to_s => {"31" => "1", "32" => "2"}} }

    user = users(:user)
    assert_difference('PlannedHour.count', -1) do
      post :save_planning, id: @project, month: '2013-08', project: { planned_hours: { user.id.to_s => {"31" => "1", "32" => "0"}} }
    end
  end

  test "should remove planned_hours when removing the user assignment" do
    project = projects(:AnotherProject)
    assert_difference('PlannedHour.count', -1) do
      put :update, id: project, project: { user_ids: [] }
    end
  end
end
