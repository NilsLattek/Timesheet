require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    sign_in users(:admin)

    @user = users(:user)
  end

  test "roles" do
    assert users(:admin).has_role? :admin
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { :email => 'newuser@localhost.de', :username => 'testuser', :password => '1234567', :password_confirmation => '1234567', :working_hours => 40 }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user, user: { :email => 'test2@localhost.de', :username => 'testuser'}
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end

  test "should remove planned_hours when removing the project assignment" do
    project = projects(:MyProject)
    assert_difference('PlannedHour.count', -1) do
      put :update, id: @user, user: { username: @user.username, project_ids: [project.id] }
    end
  end
end
