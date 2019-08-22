require 'date'
class Employee < ActiveRecord::Base
  not_multitenant!
  ADMIN_ROLE = 'Admin'.freeze
  EMPLOYEE_ROLE = 'Employee'.freeze
  TEAM_ROLE = 'Team'.freeze
  TEAM_LEAD_ROLE = 'Team Lead'.freeze
  belongs_to :company, inverse_of: :employees
  belongs_to :department
  has_many :employee_teams
  has_many :teams, through: :employee_teams, dependent: :destroy
  scope :active_members, -> { where(active: true) }
  sequenceid :company, :employees
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { minimum: 5, maximum: 50 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { scope: :company_id }
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :role, presence: true
  belongs_to :company
  has_many :messages
  accepts_nested_attributes_for :company
  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '120x120>' }, default_url: "/assets/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  has_many :tasks, as: :assignable
  has_many :attendances
  has_many :reviewer_tasks, foreign_key: :reviewer_id, class_name: 'Task'
  scope :team_employees, ->(user){joins(employee_teams: :employee).where(employee_teams: {team_id: user.employee_teams.pluck(:team_id)}).where.not(employee_teams: {employee_id: user.id}).distinct}
  scope :team_employees_projects_tasks, ->(user){joins("LEFT JOIN employee_teams ON employees.id = employee_teams.employee_id").where('employee_teams.team_id in (?) OR employees.id = ?',user.employee_teams.pluck(:team_id), user.id)}

  def todays_attendance_of_employee
    @start_time = DateTime.now.change(hour: 10)
    @end_time = DateTime.now.change(hour: 20)
    company.attendances.find_by(employee_id: id, login_time: (@start_time..@end_time))
  end

  def all_attendances
    company.attendances.where(status: Attendance::STATUS[:PRESENT]).order(login_time: :desc)
  end

  def with_company
    build_company if company.nil?
    company.build_setting if company.setting.nil?
    self
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
