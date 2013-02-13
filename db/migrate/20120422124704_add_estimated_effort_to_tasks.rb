class AddEstimatedEffortToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :estimated_effort, :float
  end
end
