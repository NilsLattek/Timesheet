class AddUserToTimesheet < ActiveRecord::Migration
  def change
    change_table :timesheets do |t|
      t.references :user
    end
    add_index :timesheets, :user_id
  end
end
