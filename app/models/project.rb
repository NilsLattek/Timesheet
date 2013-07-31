class Project < ActiveRecord::Base
  attr_accessible :name, :finished, :user_ids, :start_date, :end_date, :remaining_effort

  has_many :assignments
  has_many :users, :through => :assignments, :before_remove => :before_user_removal

  validates :name, :presence => true,
                   :length => { :minimum => 5 }

  has_many :tasks, :dependent => :destroy

  scope :active, -> { where(:finished => false).order('name') }

  validate :validate_dates

  def validate_dates
    if start_date && end_date
      errors.add("endDate", "cannot be before start date") if end_date < start_date
    end
  end

  def estimated_effort
    self.tasks.reduce(0) { |sum, task| sum + task.estimated_effort }
  end

  def actual_hours
    task_ids = self.tasks.map { |task| task.id }
    Entry.where(:task_id => task_ids).sum('hours')
  end

  def planned_hours
    PlannedHour.where(assignment_id: Assignment.select("id").where(project_id: self.id)).sum(:hours).to_f
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

  def total_actual_hours_per_week_between(start_week, end_week)
    hours = Entry.select("timesheets.user_id, timesheets.date, SUM(hours) AS hours")
                  .joins(:timesheet)
                  .where(task_id: Task.where(project_id: self.id))
                  .where("timesheets.date >= ? AND timesheets.date <= ?", start_week.beginning_of_week, end_week.end_of_week)
                  .group("timesheets.user_id, timesheets.date")

    hours = hours.reduce({}) do | result, row |
      result[row.user_id] = {} if result[row.user_id].nil?
      cweek = row.date.cweek
      result[row.user_id][cweek] = 0 if result[row.user_id][cweek].nil?
      result[row.user_id][cweek] += row.hours.to_f
      result
    end

    hours
  end

  def can_remove_project_from_user(user)
    hours = Entry.joins(:timesheet).where(timesheets: {user_id: user.id}).joins(:task).where(tasks: {project_id: self.id}).sum(:hours).to_i
    hours == 0
  end

  private

  def before_user_removal(user)
    # check if the user has already worked on this project
    if not self.can_remove_project_from_user(user)
      raise "Cannot remove user '#{user.username}', because the user has already worked on the project."
    else
      # remove assigned planned hours (reason: https://github.com/rails/rails/issues/3722)
      assignment = Assignment.find_by_user_id_and_project_id user.id, self.id
      if assignment and assignment.planned_hours
        assignment.planned_hours.each { |ph| ph.destroy }
      end
    end
  end
end
