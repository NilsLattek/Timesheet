class AddUniqueIndexToAssignments < ActiveRecord::Migration
  def change
    add_index :assignments, [:project_id, :user_id], :unique => true
  end
end
