class Project < ActiveRecord::Base
  NEW_STATUS = 'new'.freeze
  belongs_to :department
  belongs_to :company
  has_many :tasks
  validates :start_date, :expected_end_date, :name, :department_id, presence: :true
  validate :check_start_date, :check_start_and_end_date
  scope :get_projects, ->(user) { Project.joins(tasks: :project).where(tasks: {assignable_id: Employee.all.team_employees_projects_tasks(user)}).distinct }

  def check_start_and_end_date
    errors.add(:expected_end_date,'cannot be before start_time') if (expected_end_date.to_date <= start_date.to_date)
  end

  def check_start_date
    errors.add(:start_date,"should be greater than equal to today's date.") if start_date.to_date <= Date.today
  end
end
