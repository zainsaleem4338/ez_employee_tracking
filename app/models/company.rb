class Company < ActiveRecord::Base
  has_many :departments
  has_many :teams
  validates :name, presence: true, uniqueness: true, length:{ minimum: 3, maximum: 50 }
  has_many :employees, inverse_of: :company
  has_many :departments
  has_many :projects
  has_many :tasks
  has_many :teams
  has_many :attendances

end
