class UsersController < ApplicationController
  # creates @users / @user for each action which is already loaded and authorized
  load_and_authorize_resource

  respond_to :html

  # GET /users
  def index
  end

  # GET /users/1
  def show
    @hours_per_week = Entry.hours_per_week_for_user(@user).order('WEEK(date) DESC').paginate(:page => params[:page], :per_page => 7)
  end

  # GET /users/new
  def new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    flash[:notice] = 'User was successfully created.' if @user.save
    respond_with @user
  end

  # PUT /users/1
  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    flash[:notice] = 'User was successfully updated.' if @user.update_attributes(params[:user])
    respond_with @user
  end

  # DELETE /users/1
  def destroy
    flash[:notice] = 'User was successfully deleted.' if @user.destroy
    respond_with @user
  end

  def projects
    @user = User.find(params[:user_id])
    @week = Date.commercial(params[:year].to_i, params[:week].to_i)

    @projects = Project.find_for_user_by_week @user, @week
    # reformat db result so that it is easier to render
    @projects = @projects.reduce({}) do | result, row |
      result[row.name] = [] if result[row.name].nil?
      result[row.name] = row.hours.to_f
      result
    end

    @project_sum = @projects.values.reduce(0, :+)
  end
end
