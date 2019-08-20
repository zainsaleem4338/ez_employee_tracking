class Attendance < ActiveRecord::Base
  ALLOWED_STATUS = [0, 1].freeze
  STATUS = { 'PRESENT': 1, 'ABSENT': 0 }.freeze
  belongs_to :employee
  belongs_to :company
  validates :login_time, presence: true
  validates :employee_id, presence: true
  validates :status, inclusion: { in: ALLOWED_STATUS }, numericality: true
  validate :daily_limit

  def attendance_present?
    status.eql? STATUS[:PRESENT]
  end

  def daily_limit
    errors.add(:login_time, I18n.t('models.task_project.end_date_valid')) if current_employee.attendances.last.login_time.to_date == Date.today
  end
end
