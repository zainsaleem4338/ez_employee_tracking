class Department < ActiveRecord::Base
  not_multitenant!
  belongs_to :company
  has_many :projects, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :employees, dependent: :destroy
  validates :name, presence: true
  scope :get_departments, ->(user) { joins(projects: :department).where(projects: { id: Project.get_projects(user), company_id: user.company_id  }).distinct }
  scope :employee_departments, ->(user) { joins(projects: :department).where(projects: { id: Project.employee_projects(user), company_id: user.company_id }).distinct }
  scope :admin_department, ->(user){where(id: user.department_id)}
end
