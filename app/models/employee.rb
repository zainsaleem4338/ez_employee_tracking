class Employee < ActiveRecord::Base
  belongs_to :company, :inverse_of => :employees
  has_many :tasks, :as => :assignable
end
