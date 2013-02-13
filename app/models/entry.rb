class Entry < ActiveRecord::Base
  belongs_to :task
  belongs_to :timesheet
  attr_accessible :description, :hours, :task_id

  validates :description, :hours, :task_id, :presence => true
  validates_numericality_of :hours
end
