class ChangeEntryHoursTypeToDecimal < ActiveRecord::Migration
  def up
    change_column :entries, :hours, :decimal, :precision => 4, :scale => 2
  end

  def down
    change_column :entries, :hours, :float
  end
end
