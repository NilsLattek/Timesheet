class ProjectsController < ApplicationController
  include DateHelper

  load_and_authorize_resource

  before_filter :prepare_planning, :only => [:planning, :save_planning]

  respond_to :html
  respond_to :json, :only => [:index]

  # GET /projects
  def index
    @projects = @projects.order('finished, name').paginate(:page => params[:page], :per_page => 20)
  end

  # GET /projects/1
  def show
  end

  # GET /projects/new
  def new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    flash[:notice] = 'Project was successfully created.' if @project.save
    respond_with @project
  end

  # PUT /projects/1
  def update
    flash[:notice] = 'Project was successfully updated.' if @project.update_attributes(params[:project])
    respond_with @project
  end

  # DELETE /projects/1
  def destroy
    flash[:notice] = 'Project was successfully deleted.' if @project.destroy
    respond_with @project
  end

  def planning
    @planned_hours = load_planned_hours @project, @weeks
  end

  def save_planning
    planned_hours = params[:project][:planned_hours]

    @project.users.each do |user|
      weeks_for_user = planned_hours[user.id.to_s]
      assignment = Assignment.where(user_id: user.id, project_id: @project.id).first

      @weeks.each do |week|
        hours_for_week = weeks_for_user[week.cweek.to_s]

        if hours_for_week and hours_for_week.length > 0 and hours_for_week.to_f != 0.0
          ph = PlannedHour.find_or_create_by_assignment_id_and_week(assignment.id, week)
          ph.hours = hours_for_week
          ph.save
        else
          ph = PlannedHour.find_by_assignment_id_and_week(assignment.id, week)
          ph.destroy if ph
        end
      end
    end

    @planned_hours = load_planned_hours @project, @weeks
    render :planning
  end

  private

  def prepare_planning
    @selectedMonth = Date.strptime params[:month], '%Y-%m'
    @project = Project.find(params[:id])
    @weeks = cweeks_in_month @selectedMonth
  end

  # returned array looks like this:
  # array  user  week  planned_hours
  #  ph     1     32        4
  def load_planned_hours(project, weeks)
    result = {}
    planned_total_per_week = PlannedHour.total_hours_per_week_between(weeks.first, weeks.last)
    actual_total_per_week = project.total_actual_hours_per_week_between(weeks.first, weeks.last)

    project.users.each do |user|
      result[user.id] = []

      assignment = Assignment.where(user_id: user.id, project_id: project.id).first
      planned_hours = PlannedHour.where(assignment_id: assignment.id)

      weeks.each do |week|
        ph = planned_hours.select { |row| row.week == week }
        pt = planned_total_per_week.select { |row| row.week == week and row.user_id == user.id }

        result[user.id][week.cweek] = {}
        result[user.id][week.cweek][:hours] = ph[0].hours if ph.length > 0
        result[user.id][week.cweek][:working_hours] = user.working_hours
        result[user.id][week.cweek][:planned_hours] = pt.length > 0 ? pt[0].hours : 0

        actual_hours = 0
        if actual_total_per_week[user.id] && actual_total_per_week[user.id][week.cweek]
          actual_hours = actual_total_per_week[user.id][week.cweek].round(2)
        end
        result[user.id][week.cweek][:actual_hours] = actual_hours
      end
    end

    result
  end
end
