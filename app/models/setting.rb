class Setting < ActiveRecord::Base
  serialize :working_days
  serialize :timings
  belongs_to :company
end
