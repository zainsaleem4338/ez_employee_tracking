class EmployeeTeam < ActiveRecord::Base
  not_multitenant!
  belongs_to :employee
  belongs_to :team
  validates :employee_id, :team_id, :employee_type, presence: true
end
