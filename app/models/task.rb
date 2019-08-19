class Task < ActiveRecord::Base
  not_multitenant!
  EMPLOYEE = 'Employee'.freeze
  TEAM     = 'Team'.freeze
  NEW_STATUS = 'New'.freeze
  ASSIGNED_STATUS = 'Assigned'.freeze
  IN_PROGRESS = 'In Progress'.freeze
  READY_TO_REVIEW = 'Ready to Review'.freeze
  REVIEW_COMPLETED = 'Review Completed'.freeze
  UNASSIGNED_STATUS = 'unassigned'.freeze
  STATUS = [1..10].freeze
  COMPLEXITY = (1..10).freeze
  belongs_to :company
  belongs_to :project
  belongs_to :assignable, polymorphic: true
  validates :start_date, :expected_end_date, :name, :company_id, :project_id, presence: :true
  validate :check_start_date, on: :create
  validate :check_start_and_end_date
  has_many :task_time_logs, dependent: :destroy
  validates :complexity, inclusion: { in: COMPLEXITY }, numericality: true
  belongs_to :reviewer, foreign_key: :reviewer_id, class_name: EMPLOYEE
  scope :get_tasks, ->(user) { where('company_id = ? AND ((tasks.assignable_id in (?) AND tasks.assignable_type = ?) OR (tasks.assignable_id in (?) AND tasks.assignable_type = ?))', user.company_id, Employee.all.team_employees_projects_tasks(user).pluck(:id), EMPLOYEE, user.employee_teams.pluck(:team_id), TEAM) }
  scope :get_employee_tasks, ->(user) { where('company_id = ? AND ((tasks.assignable_id in (?) AND tasks.assignable_type = ?) OR (tasks.assignable_id in (?) AND tasks.assignable_type = ?))', user.company_id, user.id, EMPLOYEE, user.employee_teams.pluck(:team_id), TEAM) }

  def check_start_and_end_date
    errors.add(:expected_end_date, I18n.t('models.task_project.end_date_valid')) if expected_end_date.present? && start_date.present? && expected_end_date.to_date < start_date.to_date
  end

  def check_start_date
    errors.add(:start_date, I18n.t('models.task_project.start_date_valid')) if start_date.present? && start_date.to_date < Date.today
  end

  def get_employees(assignable_type, assignable_id)
    if assignable_type == EMPLOYEE
      company.employees.where(id: assignable_id)
    else
      company.teams.find(assignable_id).employees
    end
  end

  def self.add_email_deliver(id)
    find(id).add_email_deliver
  end

  def add_email_deliver
    employees = get_employees(self.assignable_type, self.assignable_id)
    employees.each do |employee|
      TaskMailer.assign_task_notify(employee, self).deliver
    end
  end

  def self.update_email_deliver(id, assignable_id, assignable_type, task_status)
    find(id).update_email_deliver(assignable_id, assignable_type, task_status)
  end

  def update_email_deliver(assignable_id, assignable_type, task_status)
    unless assignable_id == self.assignable_id
      previous_employees = get_employees(assignable_type, assignable_id)
      employees = get_employees(self.assignable_type, self.assignable_id)
      employees.each do |employee|
        TaskMailer.assign_task_notify(employee, self).deliver
      end
      previous_employees.each do |previous_employee|
        TaskMailer.unassign_task_notify(previous_employee, self).deliver
      end
    end
    unless task_status == self.status
      employees = get_employees(self.assignable_type, self.assignable_id)
      employees.each do |employee|
        TaskMailer.change_task_status_notify(employee, self).deliver
      end
    end
  end
  def set_status
    return self.status = Task::ASSIGNED_STATUS unless assignable_id.blank?
    self.status = Task::NEW_STATUS
    self.assignable_type = nil
  end
end
