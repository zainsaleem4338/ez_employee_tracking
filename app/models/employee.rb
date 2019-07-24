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

  def todays_attendance_of_employee(company)
    # one employee should not have multiple attendances for one day
    @start_time = DateTime.now.change(hour: 10)
    @end_time = DateTime.now.change(hour: 18)
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

  def get_team_members
  	employees = []
  	if self.role == Employee::TEAM_LEAD_ROLE
  		# binding.pry
  		self.employee_teams.each do |team|
  			# team_members = []
  			EmployeeTeam.where(team_id: team.id).each do |team_member|
  				employees << team_member.employee
  			end
  			# p team_members
  			# employees_json = {team: team.team.name, team_members: team_members}
  			# employees << e
  		end
  	else
  		p "hell"
  	end
  	employees
  end

end
