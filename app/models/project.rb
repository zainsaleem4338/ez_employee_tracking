class Project < ActiveRecord::Base
  belongs_to :department
  belongs_to :company
  has_many :tasks
  validates :start_date, :end_date, :name, :department_id, presence: :true
  validate :check_start_date, :check_start_and_end_date


  def check_start_and_end_date
    errors.add(:end_date,"cannot be before start_time") if (end_date.to_date < start_date.to_date)
  end

  def check_start_date
    errors.add(:start_date,"should be greater than equal to today's date.") if start_date.to_date < Date.today
  end

end
