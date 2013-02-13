class AddWorkingHoursToUser < ActiveRecord::Migration
  def change
    add_column :users, :working_hours, :integer
  end
end
