class DashboardController < ApplicationController
  include DateHelper

  before_filter :authenticate_user!

  def index
    @planned_hours_current_week = current_user.planned_hours_by_project_in_week(thursday_of_week(Date.today))
    @planned_hours_next_week = current_user.planned_hours_by_project_in_week(thursday_of_week(Date.today.next_week))
    @planned_hours_second_week = current_user.planned_hours_by_project_in_week(thursday_of_week(Date.today.next_week.next_week))
  end
end
