class Project < ActiveRecord::Base
  not_multitenant!
  NEW_STATUS = 'new'.freeze
  belongs_to :department
  belongs_to :company
  has_many :tasks, dependent: :destroy
  validates :start_date, :expected_end_date, :name, :department_id, presence: :true
  validate :check_start_date, on: :create
  validate :check_start_and_end_date
  scope :get_projects, ->(user) { joins(tasks: :project).where(tasks: { id: Task.all.get_tasks(user), company_id: user.company_id }).distinct }
  scope :employee_projects, ->(user) { joins(tasks: :project).where(tasks: { id: Task.all.employee_tasks(user), company_id: user.company_id }).distinct }

  def check_start_and_end_date
    errors.add(:expected_end_date, I18n.t('models.task_project.end_date_valid')) if expected_end_date.present? && start_date.present? && expected_end_date.to_date < start_date.to_date
  end

  def check_start_date
    errors.add(:start_date, I18n.t('models.task_project.start_date_valid')) if start_date.present? && start_date.to_date < Date.today
  end
end
