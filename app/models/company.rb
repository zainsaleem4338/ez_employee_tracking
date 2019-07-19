class Company < ActiveRecord::Base
  has_many :employees
  has_many :departments
  belongs_to :user
end
