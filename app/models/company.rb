class Company < ActiveRecord::Base
  not_multitenant!
  validates :name, presence: true, uniqueness: true, length:{ minimum: 3, maximum: 50 }
  has_many :employees, inverse_of: :company
  has_many :departments
  has_many :projects
  has_many :tasks
  has_many :teams
  has_many :attendances
  has_many :messages
  has_one :setting
  has_many :events
  has_many :employee_teams
  has_many :task_time_logs
  accepts_nested_attributes_for :setting

  def self.current_id=(id)
    Thread.current[:company_id] = id
  end

  def self.current_id
    Thread.current[:company_id]
  end
end
