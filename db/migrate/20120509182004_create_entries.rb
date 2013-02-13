class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.float :hours
      t.references :task
      t.references :timesheet
      t.string :description

      t.timestamps
    end
    add_index :entries, :task_id
    add_index :entries, :timesheet_id
  end
end
