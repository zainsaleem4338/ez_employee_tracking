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

  def compute_one_employee_velocity(employee_id, tasks_list)
    @total_time_on_tasks = time_spent_on_tasks(employee_id, tasks_list).to_i
    @total_task_complexity = compute_total_complexity_of_tasks(tasks_list).to_i
    (@total_task_complexity.to_f / @total_time_on_tasks)
  end

  def compute_total_complexity_of_tasks(employee_tasks)
    return 0 if employee_tasks.blank?

    employee_tasks.inject(0) { |sum, task| sum + task.complexity }
  end

  def time_spent_on_tasks(employee_id, employee_tasks)
    return 0 if employee_tasks.blank?

    @sum = 0
    employee_tasks.each do |task|
      @task_log = task.task_time_logs.where(employee_id: employee_id)
      unless @task_log.blank?
        @sum += @task_log.inject(0) { |log_sum, task_log| log_sum + task_log.hours.to_i }
      end
    end
    @sum
  end

  def compute_employees_velocity
    if role == EMPLOYEE_ROLE
      @employee_teams = teams
    elsif role == ADMIN_ROLE
      @employee_teams = company.teams
    end

    @employee_tasks_data = {}

    @employee_teams.each do |team|
      @employees_list = team.employees
      @employee_tasks_data[team.id] = {}
      @employees_list.each do |employee|
        @employee_tasks = employee.company.tasks.get_employee_tasks(employee)
        @employee_tasks_data[team.id][employee.id] = {
          employee_id: employee.id,
          employee_name: employee.name,
          total_tasks: @employee_tasks.count,
          total_time: time_spent_on_tasks(employee.id, @employee_tasks),
          total_complexity: compute_total_complexity_of_tasks(@employee_tasks),
          velocity: employee.compute_one_employee_velocity(employee.id, @employee_tasks)
        }
      end
    end
    @employee_tasks_data
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
