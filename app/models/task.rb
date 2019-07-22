class Task < ActiveRecord::Base
  belongs_to :company
  belongs_to :project
  belongs_to :assignable, :polymorphic => true
  validates :start_date, :end_date, :name, :company_id, :project_id, presence: :true
  validate :check_start_date, :check_start_and_end_date


  def check_start_and_end_date
    errors.add(:end_date,"cannot be before start_time") if (end_date.to_date < start_date.to_date)
  end

  def check_start_date
    errors.add(:start_date,"should be greater than equal to today's date.") if start_date.to_date < Date.today
  end

  def get_employee_name
    self.assignable
  end
      
  def set_status
    return self.status = "assigned" if !self.assignable_id.nil?
    self.status = "new"
    self.assignable_type = nil
  end

end
