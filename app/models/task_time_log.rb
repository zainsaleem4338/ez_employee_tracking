class TaskTimeLog < ActiveRecord::Base
  not_multitenant!
  belongs_to :task
  belongs_to :company
  belongs_to :employee
end
