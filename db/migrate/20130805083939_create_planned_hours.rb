class CreatePlannedHours < ActiveRecord::Migration
  def change
    create_table :planned_hours do |t|
      t.references :assignment
      t.date :week
      t.decimal :hours, :precision => 4, :scale => 2

      t.timestamps
    end
    add_index :planned_hours, :assignment_id
  end
end
