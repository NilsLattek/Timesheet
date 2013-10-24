class TimesheetsController < ApplicationController
  include DateHelper

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
    @planned_hours = current_user.planned_hours_by_project_in_week(thursday_of_week(@week))

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

  def new_multiple
    @timesheet = Timesheet.new
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

  def create_multiple
    @timesheet = Timesheet.new params[:timesheet]
    iterator, @start_date, @end_date = nil
    begin
      iterator = Date.parse params[:start_date]
      @start_date = iterator
      @end_date = Date.parse params[:end_date]
    rescue
      flash[:error] = 'Invalid date'
      render :new_multiple
      return
    end

    if @start_date > @end_date
      flash[:error] = 'End date cannot be before start date'
      render :new_multiple
      return
    end

    success = true
    new_timesheet = nil
    timesheet_count = 0

    while iterator <= @end_date do
      if iterator.cwday == 6 or iterator.cwday == 7
        iterator = iterator.next_day
        next
      end

      new_timesheet = @timesheet.dup
      new_timesheet.user = current_user
      @timesheet.entries.each do |entry|
        new_timesheet.entries.push entry.dup
      end
      new_timesheet.date = iterator
      success = new_timesheet.save
      break if not success

      timesheet_count += 1
      iterator = iterator.next_day
    end

    if success
      flash[:notice] = "#{timesheet_count} timesheets created"
      redirect_to :action => :weekly, :year => @start_date.year, :week => @start_date.cweek
    else
      @timesheet = new_timesheet
      render :new_multiple
    end
  end

  # PUT /timesheets/1
  def update
    flash[:notice] = 'Timesheet was successfully updated.' if @timesheet.update_attributes(params[:timesheet])
    respond_with @timesheet
  end

  # DELETE /timesheets/1
  def destroy
    flash[:notice] = 'Timesheet was successfully deleted.' if @timesheet.destroy
    respond_with @timesheet, :location => weekly_timesheets_path(@timesheet.date.year, @timesheet.date.cweek)
  end
end
