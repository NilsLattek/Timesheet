class CreateProjectsUsers < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.belongs_to :project
      t.belongs_to :user
    end
  end
end
