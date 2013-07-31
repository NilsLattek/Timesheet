class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_many :assignments
  has_many :projects, :through => :assignments, before_remove: :before_project_removal
  has_many :timesheets, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :registerable,
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_ids, :username, :working_hours, :active, :project_ids
  # attr_accessible :title, :body

  validates :username, :working_hours, :presence => true

  scope :active, -> { where(:active => true).order('username') }

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def active_for_authentication?
    super && active
  end

  def can_remove_user_from_project(project)
    hours = Entry.joins(:timesheet).where(timesheets: {user_id: self.id}).joins(:task).where(tasks: {project_id: project.id}).sum(:hours).to_i
    hours == 0
  end

  def planned_hours_by_project_in_week(week)
    PlannedHour.select("projects.name, SUM(planned_hours.hours) AS hours")
               .joins(:assignment => :project)
               .where(assignments: {user_id: self.id})
               .where("planned_hours.week >= ? AND planned_hours.week <= ?", week, week)
               .order("projects.name")
               .group("projects.name")
  end

  private

  def before_project_removal(project)
    # check if the user has already worked on this project
    if not self.can_remove_user_from_project(project)
      raise "Cannot remove project '#{project.name}', because the user has already worked on it."
    else
      # remove assigned planned hours (reason: https://github.com/rails/rails/issues/3722)
      assignment = Assignment.find_by_user_id_and_project_id self.id, project.id
      if assignment and assignment.planned_hours
        assignment.planned_hours.each { |ph| ph.destroy }
      end
    end
  end
end
