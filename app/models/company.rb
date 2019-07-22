class Company < ActiveRecord::Base
  has_many :employees, :inverse_of => :company
  has_many :departments
  has_many :projects
  has_many :tasks
  has_many :teams
end
