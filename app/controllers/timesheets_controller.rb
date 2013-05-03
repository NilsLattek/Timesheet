class TimesheetsController < ApplicationController
  load_and_authorize_resource :through => :current_user

  respond_to :html

  # GET /timesheets
  def index
    @timesheets = @timesheets.order('date DESC').paginate(:page => params[:page], :per_page => 10)
  end

  # GET /timesheets/cw/20
  def weekly
    #@week = Date.strptime(params[:week], '%W')
    @week = Date.commercial(params[:year].to_i, params[:week].to_i)
    @timesheets = @timesheets.where(:date => (@week.beginning_of_week)..(@week.end_of_week)).order('date DESC')
    @hours_worked = @timesheets.inject(0){|sum, item| sum + item.hours_worked}.round 2

    respond_with(@timesheets) do |format|
      format.html
      format.print { render :action => 'index', :layout => false }
    end
  end

  # GET /timesheets/1
  def show
  end

  # GET /timesheets/new
  def new
    @timesheet.date = Date.today
    @timesheet.lunch_break = 30
    @timesheet.entries.build
  end

  # GET /timesheets/1/edit
  def edit
  end

  # POST /timesheets
  def create
    flash[:notice] = 'Timesheet was successfully created.' if @timesheet.save
    respond_with @timesheet
  end

  # PUT /timesheets/1
  def update
    flash[:notice] = 'Timesheet was successfully updated.' if @timesheet.update_attributes(params[:timesheet])
    respond_with @timesheet
  end

  # DELETE /timesheets/1
  def destroy
    flash[:notice] = 'Timesheet was successfully deleted.' if @timesheet.destroy
    respond_with @timesheet, :location => weekly_timesheets_path(Date.today.year, Date.today.cweek)
  end
end
