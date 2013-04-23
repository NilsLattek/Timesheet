class ProjectsController < ApplicationController
  load_and_authorize_resource

  respond_to :html

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
end
