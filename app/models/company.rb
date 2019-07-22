class Company < ActiveRecord::Base
  validates :name, presence: true

  has_many :employees
  has_many :attendances
end
