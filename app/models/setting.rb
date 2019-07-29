class Setting < ActiveRecord::Base
  serialize :working_days
  belongs_to :company
end