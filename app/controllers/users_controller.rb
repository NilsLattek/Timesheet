class UsersController < ApplicationController
  include DateHelper

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

    flash[:notice] = 'User was successfully updated.' if @user.update(user_params)
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

  def utilizations
    @selectedMonth = Date.strptime params[:month], '%Y-%m'
    @weeks = cweeks_in_month @selectedMonth
    users = User.developer
    phs = PlannedHour.total_hours_per_week_between @weeks.first, @weeks.last

    @planned_hours = []
    users.each do |user|
      @weeks.each do |week|
        hours_in_week = phs.select { |row| row.week == week and row.user_id == user.id }
        hours_in_week = hours_in_week.length > 0 ? hours_in_week[0].hours.to_f : 0

        ph = @planned_hours.select { |row| row[:user] == user }

        if ph.length > 0
          # attach week
          ph[0][:utilization] << {week: week, hours: hours_in_week}
        else
          @planned_hours << {
            user: user,
            utilization: [{week: week, hours: hours_in_week}]
          }
        end
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(:working_hours, :email, :username, :password, :password_confirmation, :active, :role_ids => [], :project_ids => [])
    end
end
