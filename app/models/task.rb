class Task < ActiveRecord::Base
  belongs_to :company
  belongs_to :project
  belongs_to :assignable, :polymorphic => true
  validates :start_date, :expected_end_date, :name, :company_id, :project_id, presence: :true
  validate :check_start_date, :check_start_and_end_date


  def check_start_and_end_date
    errors.add(:expected_end_date,"cannot be before start_time") if (expected_end_date.to_date < start_date.to_date)
  end

  def check_start_date
    errors.add(:start_date,"should be greater than equal to today's date.") if start_date.to_date < Date.today
  end

  def set_status
    return self.status = "assigned" if !self.assignable_id.nil?
    self.status = "new"
    self.assignable_type = nil
  end

  def set_assignable(assignable_team_id, assignable_employee_id,assignable_type)
    if !assignable_team_id.empty?
      self.assignable_id = assignable_team_id
      self.assignable_type = "Team"
    elsif !assignable_employee_id.empty?
      self.assignable_id = assignable_employee_id
      self.assignable_type = "Employee"
    end
  end

  def update_assignable(assignable_team_id, assignable_employee_id,assignable_type)
    if (self.assignable_type == "Employee" && assignable_type == "Employee" && assignable_employee_id == self.assignable_id) ||
      (self.assignable_type == "Team" && assignable_type == "Team" && assignable_employee_id == self.assignable_id)
      return
    else 
      if assignable_type == "Employee"
        self.update(:assignable_type => assignable_type, :assignable_id => assignable_employee_id, :status => "assigned") if !assignable_employee_id.empty?
        self.update(:assignable_type => nil, :assignable_id => nil, :status => "new") if assignable_employee_id.empty?
      elsif assignable_type == "Team"
        self.update(:assignable_type => assignable_type, :assignable_id => assignable_team_id, :status => "Team")
      end

    end
  end

end
