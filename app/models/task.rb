class Task < ActiveRecord::Base
  EMPLOYEE = 'Employee'.freeze
  TEAM     = 'Team'.freeze
  NEW_STATUS = 'new'.freeze
  ASSIGNED_STATUS = 'assigned'.freeze
  COMPLEXITY = (1..10).freeze
  belongs_to :company
  belongs_to :project
  belongs_to :assignable, polymorphic: true
  # validates :complexity, inclusion: { in: COMPLEXITY }, numericality: true
  validates :start_date, :expected_end_date, :name, :company_id, :project_id, presence: :true
  validate :check_start_date, :check_start_and_end_date
  scope :get_tasks, ->(user){where('(tasks.assignable_id in (?) AND tasks.assignable_type = ?) OR (tasks.assignable_id in (?) AND tasks.assignable_type = ?)',Employee.all.team_employees_projects_tasks(user).pluck(:id) , "Employee",user.employee_teams.pluck(:team_id),"Team")}
  scope :get_employee_tasks, ->(user){ where('(tasks.assignable_id in (?) AND tasks.assignable_type = ?) OR (tasks.assignable_id in (?) AND tasks.assignable_type = ?)',user.id , "Employee",user.employee_teams.pluck(:team_id),"Team")}
  
  def check_start_and_end_date
    errors.add(:expected_end_date,'cannot be before start_time') if (expected_end_date.to_date < start_date.to_date)
  end

  def check_start_date
    errors.add(:start_date,"should be greater than equal to today's date.") if start_date.to_date < Date.today
  end

  def get_employees(assignable_type, assignable_id)
    if assignable_type == EMPLOYEE
      company.employees.where(id: assignable_id)
    else
      company.teams.find(assignable_id).employees
    end
  end

  def set_status
    return status = Task::ASSIGNED_STATUS unless assignable_id.nil?
    
    status = Task::NEW_STATUS
    assignable_type = nil
  end
end
