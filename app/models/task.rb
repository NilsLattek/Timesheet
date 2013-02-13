class Task < ActiveRecord::Base
  belongs_to :project
  attr_accessible :name, :project_id, :estimated_effort

  validates :name, :presence => true,
                   :length => { :minimum => 5 }

  validates :estimated_effort, :presence => true
end
