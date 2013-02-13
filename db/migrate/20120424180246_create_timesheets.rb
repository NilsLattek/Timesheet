class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.date :date
      t.time :start_time
      t.time :end_time
      t.integer :lunch_break

      t.timestamps
    end
  end
end
