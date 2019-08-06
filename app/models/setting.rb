class Setting < ActiveRecord::Base
  serialize :working_days
  serialize :timings
  serialize :holidays
  belongs_to :company

end
