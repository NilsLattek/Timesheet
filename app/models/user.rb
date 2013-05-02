class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_many :timesheets, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :registerable,
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_ids, :username, :working_hours, :active
  # attr_accessible :title, :body

  validates :username, :presence => true

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def active_for_authentication?
    super && active
  end
end
