class TasksController < ApplicationController
  load_and_authorize_resource

  # GET /tasks/1
  # GET /tasks/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    #@chapter = @book.chapters.build
    #http://stackoverflow.com/questions/3784183/rails-3-how-to-create-a-new-nested-resource
    @task = Task.new
    project = Project.find(params[:project_id])
    @task.project = project

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])
    
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task.project, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task.project, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to @task.project }
      format.json { head :no_content }
    end
  end
end
