class Department < ActiveRecord::Base
  belongs_to :company
  has_many :projects
  has_many :teams
  has_many :employees
  validates :name, presence: true
end
