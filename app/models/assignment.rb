class Assignment < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  has_many :planned_hours, :dependent => :destroy
end
