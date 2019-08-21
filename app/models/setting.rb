class Setting < ActiveRecord::Base
  cattr_accessor :on_days, :daily_timings
  @week_timings = ['monday_start_time', 'monday_end_time', 'tuesday_start_time',
                'tuesday_end_time', 'wednesday_start_time', 'wednesday_end_time',
                'thursday_start_time', 'thursday_end_time', 'friday_start_time',
                'friday_end_time', 'saturday_start_time', 'saturday_end_time',
                'sunday_start_time', 'sunday_end_time']
  @days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']
  serialize :working_days
  serialize :timings
  serialize :holidays
  belongs_to :company

  def self.on_days(params)
    on_days = {}
    @days.each do |day|
      params[day].blank? ? on_days[day] = false : on_days[day] = true
    end
    on_days
  end

  def self.daily_timings(params)
    timings = {}
    @week_timings.each do |timing|
      params[timing].blank? ? timings[timing] = '00:00 AM' : timings[timing] = params[timing]
    end
    timings
  end

  def self.set_up_settings
    
  end
end
