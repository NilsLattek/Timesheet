class TasksController < ApplicationController
  load_and_authorize_resource

  respond_to :html

  # GET /tasks/1
  def show
    @entries = @task.entries.joins(:timesheet).order('date DESC').paginate(:page => params[:page], :per_page => 10)
  end

  # GET /tasks/new
  def new
    #@chapter = @book.chapters.build
    #http://stackoverflow.com/questions/3784183/rails-3-how-to-create-a-new-nested-resource
    @task = Task.new
    project = Project.find(params[:project_id])
    @task.project = project
    @task.estimated_effort = 0
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    flash[:notice] = 'Task was successfully created.' if @task.save
    respond_with @task, :location => project_path(@task.project)
  end

  # PUT /tasks/1
  def update
    flash[:notice] = 'Task was successfully updated.' if @task.update(task_params)
    respond_with @task, :location => project_path(@task.project)
  end

  # DELETE /tasks/1
  def destroy
    flash[:notice] = 'Task was successfully deleted.' if @task.destroy
    respond_with @task, :location => project_path(@task.project)
  end

  private

    def task_params
      params.require(:task).permit(:name, :project_id, :estimated_effort, :finished)
    end
end
