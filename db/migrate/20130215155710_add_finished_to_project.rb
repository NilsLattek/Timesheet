class AddFinishedToProject < ActiveRecord::Migration
  def change
    add_column :projects, :finished, :boolean, :default => false
  end
end
