require 'date'

class Employee < ActiveRecord::Base
  ADMIN_ROLE = 'Admin'.freeze
  EMPLOYEE_ROLE = 'Employee'.freeze
  TEAM_ROLE = 'Team'.freeze
  STATUS = { 'PRESENT': 1, 'ABSENT': 0 }.freeze
  TEAM_LEAD_ROLE = 'Team Lead'.freeze
  belongs_to :company, :inverse_of => :employees
  belongs_to :department
  has_many :employee_teams
  has_many :teams, through: :employee_teams, dependent: :destroy
  scope :active_members, -> { where(active: true) }
  sequenceid :company, :employees
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { minimum: 5, maximum: 50 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { scope: :company_id }
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :role, presence: true
  accepts_nested_attributes_for :company
  has_many :tasks, :as => :assignable
  has_many :attendances
  scope :team_employees, ->(user){joins(employee_teams: :employee).where(employee_teams: {team_id: user.employee_teams.pluck(:team_id)}).where.not(employee_teams: {employee_id: user.id}).distinct}
  scope :team_employees_projects_tasks, ->(user){joins(employee_teams: :employee).where(employee_teams: {team_id: user.employee_teams.pluck(:team_id)}).distinct}

  def todays_attendance_of_employee
    # one employee should not have multiple attendances for one day
    @start_time = DateTime.now.change(hour: 10)
    @end_time = DateTime.now.change(hour: 20)
    self.company.attendances.find_by(employee_id: id, login_time: (@start_time..@end_time))
  end

  def with_company
    build_company if company.nil?
    self
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
  
  def get_attendances_admin
      self.company.attendances.where(status: STATUS[:PRESENT]).order(login_time: :desc)
  end
end
