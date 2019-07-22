class Attendance < ActiveRecord::Base
  STATUS = [0, 1].freeze
  belongs_to :employee
  belongs_to :company

  validates :login_time, presence: true
  validates :employee_id, presence: true
  validates :status, inclusion: { in: STATUS }, numericality: true
end
