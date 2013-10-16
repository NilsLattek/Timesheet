json.array! @projects do |project|
  json.(project, :id, :name, :start_date, :end_date, :finished, :actual_hours, :remaining_effort)
  json.original_effort project.estimated_effort
end