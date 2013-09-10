class PlannedHour < ActiveRecord::Base
  belongs_to :assignment
  has_one :project, :through => :assignment
  has_one :user, :through => :assignment

  validates_numericality_of :hours, :greater_than_or_equal_to => 0

  def self.total_hours_per_week_between(start_week, end_week)
    self.select("user_id, week, SUM(hours) AS hours").joins(:assignment).where("week >= ? AND week <= ?", start_week, end_week).group("user_id, week")
  end
end
