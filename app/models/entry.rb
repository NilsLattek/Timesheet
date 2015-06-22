class Entry < ActiveRecord::Base
  belongs_to :task
  belongs_to :timesheet

  validates :description, :hours, :task_id, :presence => true
  validates_numericality_of :hours, :greater_than_or_equal_to => 0

  def editable?
    # new entry, not assigned to any task
    return true if not task.present?

    !task.project.finished && !task.finished
  end

  def self.hours_per_week_for_user user
    Entry.select(%{ SUM(hours) AS hours, WEEK(date, 3) AS week }).joins(:timesheet).where('timesheets.user_id = ?', user.id).group('YEARWEEK(date, 3)')
  end
end
