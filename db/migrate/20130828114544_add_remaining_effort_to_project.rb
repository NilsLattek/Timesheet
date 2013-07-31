class AddRemainingEffortToProject < ActiveRecord::Migration
  def change
    add_column :projects, :remaining_effort, :decimal, :precision => 4, :scale => 2
  end
end
