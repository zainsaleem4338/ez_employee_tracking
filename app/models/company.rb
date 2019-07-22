class Company < ActiveRecord::Base
  belongs_to :employee
  has_many :employees
  has_many :departments
end
