require 'date'

class Employee < ActiveRecord::Base

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
  
  validates :password, presence: true, length: { minimum: 4 }

  has_many :attendances
  belongs_to :company

  def todays_attendance_of_employee(company)
    # one employee should not have multiple attendances for one day
    @start_time = DateTime.now.change(hour: 10)
    @end_time = DateTime.now.change(hour: 18)
    company.attendances.find_by(employee_id: id, login_time: (@start_time..@end_time))
  end
end
