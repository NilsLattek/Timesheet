class AddUsernameToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :username, :null => false, :default => ""
    end
  end
end
