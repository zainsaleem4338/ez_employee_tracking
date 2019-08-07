class Department < ActiveRecord::Base
  belongs_to :company
  has_many :projects, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :employees, dependent: :destroy
  validates :name, presence: true
  scope :get_departments, ->(user) { joins(projects: :department).where(projects: { id: Project.get_projects(user) }).distinct }
  scope :employee_departments, ->(user) { joins(projects: :department).where(projects: { id: Project.employee_projects(user) }).distinct }
end
