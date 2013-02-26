class TimesheetsController < ApplicationController
  load_and_authorize_resource :through => :current_user

  respond_to :html, :json

  # GET /timesheets
  # GET /timesheets.json
  def index
    @timesheets = @timesheets.order('date DESC').paginate(:page => params[:page], :per_page => 10)

  end

  # GET /timesheets/cw/20
  # GET /timesheets/cw/20.json
  def weekly
    #@week = Date.strptime(params[:week], '%W')
    @week = Date.commercial(params[:year].to_i, params[:week].to_i)
    @timesheets = @timesheets.where(:date => (@week.beginning_of_week)..(@week.end_of_week)).order('date DESC')
    @hours_worked = @timesheets.inject(0){|sum, item| sum + item.hours_worked}

    respond_with(@timesheets) do |format|
      format.html { render :action => 'index' }
      format.print { render :action => 'index', :layout => false }
    end
  end

  # GET /timesheets/1
  # GET /timesheets/1.json
  def show

  end

  # GET /timesheets/new
  # GET /timesheets/new.json
  def new
    @timesheet.date = Date.today
    @timesheet.lunch_break = 30
    @timesheet.entries.build

  end

  # GET /timesheets/1/edit
  def edit
  end

  # POST /timesheets
  # POST /timesheets.json
  def create
    respond_to do |format|
      if @timesheet.save
        format.html { redirect_to @timesheet, notice: 'Timesheet was successfully created.' }
        format.json { render json: @timesheet, status: :created, location: @timesheet }
      else
        format.html { render action: "new" }
        format.json { render json: @timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /timesheets/1
  # PUT /timesheets/1.json
  def update

    respond_to do |format|
      if @timesheet.update_attributes(params[:timesheet])
        format.html { redirect_to @timesheet, notice: 'Timesheet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timesheets/1
  # DELETE /timesheets/1.json
  def destroy
    @timesheet.destroy

    respond_to do |format|
      format.html { redirect_to weekly_timesheets_path(Date.today.year, Date.today.cweek) }
      format.json { head :no_content }
    end
  end
end
