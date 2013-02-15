class Project < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true,
                   :length => { :minimum => 5 }

  has_many :tasks

  def estimated_effort
    self.tasks.reduce(0) { |sum, task| sum + task.estimated_effort }
  end

  def actual_hours
    task_ids = self.tasks.map { |task| task.id }
    Entry.where(:task_id => task_ids).sum('hours')
  end
end
