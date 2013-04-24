class Entry < ActiveRecord::Base
  belongs_to :task
  belongs_to :timesheet
  attr_accessible :description, :hours, :task_id

  validates :description, :hours, :task_id, :presence => true
  validates_numericality_of :hours, :greater_than_or_equal_to => 0

  def editable?
    # new entry, not assigned to any task
    return true if not task.present?

    !task.project.finished
  end

  def self.hours_per_week_for_user user
    Entry.select(%{ SUM(hours) AS hours, WEEK(date, 1) AS week }).joins(:timesheet).where('timesheets.user_id = ?', user.id).group('WEEK(date, 1)')
  end
end
