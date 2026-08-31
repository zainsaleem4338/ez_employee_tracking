class EmployeeTeam < ActiveRecord::Base
  belongs_to :employee
  belongs_to :team
  belongs_to :company
  accepts_nested_attributes_for :employee
end
