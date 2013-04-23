class RolesController < ApplicationController
  load_and_authorize_resource

  respond_to :html

  # GET /roles
  def index
  end

  # GET /roles/1
  def show
  end

  # GET /roles/new
  def new
  end

  # GET /roles/1/edit
  def edit
  end

  # POST /roles
  def create
    flash[:notice] = 'Role was successfully created.' if @role.save
    respond_with @role
  end

  # PUT /roles/1
  def update
    flash[:notice] = 'Role was successfully updated.' if @role.update_attributes(params[:role])
    respond_with @role
  end

  # DELETE /roles/1
  def destroy
    flash[:notice] = 'Role was successfully deleted.' if @role.destroy
    respond_with @role
  end
end
