class Task < ActiveRecord::Base
  EMPLOYEE = 'Employee'.freeze
  TEAM     = 'Team'.freeze
  NEW_STATUS = 'new'.freeze
  ASSIGNED_STATUS = 'assigned'.freeze
  belongs_to :company
  belongs_to :project
  belongs_to :assignable, polymorphic: true
  validates :start_date, :expected_end_date, :name, :company_id, :project_id, presence: :true
  validate :check_start_date, :check_start_and_end_date
  scope :get_tasks, ->(user){where('(tasks.assignable_id in (?) AND tasks.assignable_type = ?) OR (tasks.assignable_id in (?) AND tasks.assignable_type = ?)',Employee.all.team_employees_projects_tasks(user) , "Employee",user.employee_teams.pluck(:team_id),"Team")}

  def check_start_and_end_date
    errors.add(:expected_end_date,'cannot be before start_time') if (expected_end_date.to_date < start_date.to_date)
  end

  def check_start_date
    errors.add(:start_date,"should be greater than equal to today's date.") if start_date.to_date < Date.today
  end

  def set_status
    return self.status = Task::ASSIGNED_STATUS unless self.assignable_id.nil?
    self.status = Task::NEW_STATUS
    self.assignable_type = nil
  end

  # def set_assignable(assignable_team_id, assignable_employee_id,assignable_type)
  #   unless assignable_team_id.empty?
  #     self.assignable_id = assignable_team_id
  #     self.assignable_type = Task::TEAM
  #   end
  #   unless assignable_employee_id.empty?
  #     self.assignable_id = assignable_employee_id
  #     self.assignable_type = Task::EMPLOYEE
  #   end
  # end

  # def update_assignable(assignable_team_id, assignable_employee_id,assignable_type)
  #   binding.pry
  #   if (self.assignable_type == Task::EMPLOYEE && assignable_type == Task::EMPLOYEE && assignable_employee_id == self.assignable_id) ||
  #     (self.assignable_type == Task::TEAM && assignable_type == Task::TEAM && assignable_employee_id == self.assignable_id)
  #     return
  #   else
  #     if assignable_type == Task::EMPLOYEE
  #       self.update(assignable_type: assignable_type, assignable_id: assignable_employee_id, status: Task::ASSIGNED_STATUS) unless assignable_employee_id.empty?
  #       self.update(assignable_type: nil, assignable_id: nil, status: Task::NEW_STATUS) if assignable_employee_id.empty?
  #     elsif assignable_type == Task::TEAM
  #       self.update(assignable_type: assignable_type, assignable_id: assignable_team_id, status: Task::TEAM)
  #     end
  #   end
  # end

end
