require 'date'

class Employee < ActiveRecord::Base
  ADMIN_ROLE = 'Admin'.freeze
  EMPLOYEE_ROLE = 'Employee'.freeze
  TEAM_ROLE = 'Team'.freeze
  STATUS = { 'PRESENT': 1, 'ABSENT': 0 }.freeze
  TEAM_LEAD_ROLE = 'Team Lead'.freeze
  belongs_to :company, inverse_of: :employees
  belongs_to :department
  has_many :employee_teams
  has_many :teams, through: :employee_teams, dependent: :destroy
  scope :active_members, -> { where(active: true) }
  sequenceid :company, :employees
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { minimum: 5, maximum: 50 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { scope: :company_id }
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :role, presence: true
  accepts_nested_attributes_for :company
  has_many :tasks, as: :assignable
  has_many :attendances
  scope :team_employees, ->(user) { joins(employee_teams: :employee).where(employee_teams: { team_id: user.employee_teams.pluck(:team_id) }).where.not(employee_teams: { employee_id: user.id }).distinct }
  scope :team_employees_projects_tasks, ->(user) { joins('LEFT JOIN employee_teams ON employees.id = employee_teams.employee_id').where('employee_teams.team_id in (?) OR employees.id = ?', user.employee_teams.pluck(:team_id), user.id) }

  def todays_attendance_of_employee
    # one employee should not have multiple attendances for one day
    @start_time = DateTime.now.change(hour: 10)
    @end_time = DateTime.now.change(hour: 20)
    company.attendances.find_by(employee_id: id, login_time: (@start_time..@end_time))
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
    company.attendances.where(status: STATUS[:PRESENT]).order(login_time: :desc)
  end

  def attendance_data
    end_date = "31-12-#{Date.today.year}".to_date
    week_days = [1, 2, 3, 4, 5]
    attendances_array = []
    company.employees.each do |employee|
      @attendances = employee.attendances.where('status = ?', STATUS[:PRESENT]).order(login_time: :asc).select { |attendance| attendance.login_time.year == Date.today.year }
      expected_working_days = (@attendances.first.login_time.to_date..@attendances.last.login_time.to_date).to_a.select { |k| week_days.include?(k.wday) }.count
      leaves = (end_date.month - @attendances.first.login_time.month + 1) * 2
      actual_working_days = @attendances.count
      half_days = @attendances.select { |attendance| ((attendance.logout_time - attendance.login_time) / 3600) <= 6 }.count
      full_days = actual_working_days - half_days
      absents = expected_working_days - actual_working_days - (half_days / 2).floor
      attendances_array << {
        employee: employee,
        presents: full_days,
        half_days: half_days,
        absents: absents,
        leaves_remaining: leaves - absents
      }
    end
    attendances_array
  end
end
