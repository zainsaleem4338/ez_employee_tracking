class Attendance < ActiveRecord::Base
  ALLOWED_STATUS = [0, 1].freeze
  STATUS = { 'PRESENT': 1, 'ABSENT': 0 }.freeze
  belongs_to :employee
  belongs_to :company
  validates :login_time, presence: true
  validates :employee_id, presence: true
  validates :status, inclusion: { in: ALLOWED_STATUS }, numericality: true

  def attendance_present?
    status.eql? STATUS[:PRESENT]
  end
end
