class Company < ActiveRecord::Base
  has_many :departments
  has_many :teams
  validates :name, presence: true, uniqueness: true,
            length:
            {
              minimum: 3,
              maximum: 50
            }
  has_many :employees
end
