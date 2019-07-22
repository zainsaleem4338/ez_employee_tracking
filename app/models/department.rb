class Department < ActiveRecord::Base
  belongs_to :company
  has_many :projects
end
