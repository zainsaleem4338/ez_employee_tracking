class Department < ActiveRecord::Base
  belongs_to :company
  has_many :projects
  has_many :teams
  has_many :employees
  validates :name, presence: true
  scope :get_departments, ->(user){ joins(projects: :department).where(projects: {:id => Employee.all.team_employees_projects_tasks(user) }).distinct}
end
