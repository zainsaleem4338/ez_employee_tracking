require 'date'

class Employee < ActiveRecord::Base
  ADMIN_ROLE = 'Admin'.freeze
  EMPLOYEE_ROLE = 'Employee'.freeze
  TEAM_ROLE = 'Team'.freeze
  TEAM_LEAD_ROLE = 'Team Lead'.freeze
  belongs_to :company, :inverse_of => :employees
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
  accepts_nested_attributes_for :company
  has_many :tasks, :as => :assignable
  has_many :attendances
  scope :team_employees, ->(user){joins(employee_teams: :employee).where(employee_teams: {team_id: user.employee_teams.pluck(:team_id)}).where.not(employee_teams: {employee_id: user.id}).distinct}
  scope :team_employees_projects_tasks, ->(user){joins(employee_teams: :employee).where(employee_teams: {team_id: user.employee_teams.pluck(:team_id)}).distinct}

  def todays_attendance_of_employee
    @start_time = DateTime.now.change(hour: 10)
    @end_time = DateTime.now.change(hour: 20)
    attendances.find_by(login_time: (@start_time..@end_time))
  end

  def with_company
    build_company if company.nil?
    self
  end

  def compute_one_employee_velocity(tasks_list)
    @total_time_on_tasks = time_spent_on_tasks(tasks_list)
    @total_task_complexity = compute_total_complexity_of_tasks(tasks_list)
    (@total_task_complexity.to_f / @total_time_on_tasks)
  end

  def compute_total_complexity_of_tasks(employee_tasks)
    return 0 if employee_tasks.blank?
    employee_tasks.inject(0) { |sum, task| sum + task.complexity }
  end

  def time_spent_on_tasks(employee_tasks)
    return 0 if employee_tasks.blank?
    employee_tasks.inject(0) { |sum, task| sum + task.log_time.to_i }
  end

  def compute_employees_velocity
    @employees_list = company.employees
    @employee_tasks = {}
    @employee_velocity = {}
    @employees_list.each do |employee|
      @employee_tasks[employee.id] = employee.company.tasks.get_employee_tasks(employee)
      @employee_velocity[employee.id] = employee.compute_one_employee_velocity(@employee_tasks[employee.id])
    end
    return @employee_tasks, @employee_velocity
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
