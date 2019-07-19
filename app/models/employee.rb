class Employee < ActiveRecord::Base
  belongs_to :company
  belongs_to :department
  has_many :employee_teams
  has_many :teams, through: :employee_teams, dependent: :destroy
end
