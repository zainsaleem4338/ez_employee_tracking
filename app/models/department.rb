class Department < ActiveRecord::Base
  belongs_to :company
  has_many :projects
  has_many :teams
  has_many :employees
  validates :name, presence: true
  scope :get_departments, ->(user){ joins(projects: :department).where(projects: {:id => Project.get_projects(user) }).distinct}
  scope :employee_departments, ->(user){ joins(projects: :department).where(projects: {:id => Project.employee_projects(user) }).distinct}
end
