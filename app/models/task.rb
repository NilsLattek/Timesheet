class Task < ActiveRecord::Base
  belongs_to :project
  has_many :entries

  validates :name, :presence => true,
                   :length => { :minimum => 5 }

  validates :estimated_effort, :presence => true
  validates_numericality_of :estimated_effort, :greater_than_or_equal_to => 0

  def actual_hours
    self.entries.sum('hours')
  end
end
