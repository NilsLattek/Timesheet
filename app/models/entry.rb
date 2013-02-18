class Entry < ActiveRecord::Base
  belongs_to :task
  belongs_to :timesheet
  attr_accessible :description, :hours, :task_id

  validates :description, :hours, :task_id, :presence => true
  validates_numericality_of :hours

  def editable?
    # new entry, not assigned to any task
    return true if not task.present?

    !task.project.finished
  end
end
