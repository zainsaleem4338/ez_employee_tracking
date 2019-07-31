class Company < ActiveRecord::Base
	not_multitenant!
  has_many :departments
  has_many :teams
  validates :name, presence: true, uniqueness: true,
            length:
            {
              minimum: 3,
              maximum: 50
            }
  has_many :employees
  has_many :messages
  has_many :attendances
  has_one :setting
  has_many :events
  accepts_nested_attributes_for :setting

  def self.current_id=(id)
    Thread.current[:company_id] = id
  end

  def self.current_id
    Thread.current[:company_id]
  end
end
