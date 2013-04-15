class Project < ActiveRecord::Base
  attr_accessible :name, :finished

  validates :name, :presence => true,
                   :length => { :minimum => 5 }

  has_many :tasks, :dependent => :destroy

  scope :active, -> { where(:finished => false).order('name') }

  def estimated_effort
    self.tasks.reduce(0) { |sum, task| sum + task.estimated_effort }
  end

  def actual_hours
    task_ids = self.tasks.map { |task| task.id }
    Entry.where(:task_id => task_ids).sum('hours')
  end

  def self.find_for_user_by_week user, week
    sql = "SELECT p.id, p.name, SUM(e.hours) AS hours
           FROM projects p LEFT JOIN tasks t
           ON p.id = t.project_id
           LEFT JOIN entries e
           ON t.id = e.task_id
           WHERE e.timesheet_id IN (SELECT id FROM timesheets WHERE user_id = ? AND date BETWEEN ? AND ?)
           GROUP by p.id
           HAVING SUM(e.hours) IS NOT NULL"

    Project.find_by_sql [sql, user.id, week.beginning_of_week, week.end_of_week]
  end
end
