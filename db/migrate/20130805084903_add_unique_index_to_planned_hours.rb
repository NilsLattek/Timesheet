class AddUniqueIndexToPlannedHours < ActiveRecord::Migration
  def change
    add_index :planned_hours, [:assignment_id, :week], :unique => true
  end
end
