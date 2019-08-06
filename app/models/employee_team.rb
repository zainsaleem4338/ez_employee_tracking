class EmployeeTeam < ActiveRecord::Base
  belongs_to :employee
  belongs_to :team
  belongs_to :company
  validates :employee_id, :team_id, :employee_type, presence: true
end
