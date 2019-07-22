class Company < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true,
            length:
            {
              minimum: 3,
              maximum: 50
            }
  has_many :employees
end
