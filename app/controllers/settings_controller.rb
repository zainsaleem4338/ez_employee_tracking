class SettingsController < ApplicationController
  load_and_authorize_resource

  def index
    @settings = @settings.first
    if @settings.present?
      if(@settings.working_days.class == String)
        @settings.working_days = JSON.parse(@settings.working_days.gsub("'",'"').gsub('=>',':'))
        @settings.timings = JSON.parse(@settings.timings.gsub("'",'"').gsub('=>',':'))
      end
      @settings
    end
  end

  def edit
    @settings = @settings.first
    if @settings.present?
      if(@settings.working_days.class == String)
        @settings.working_days = JSON.parse(@settings.working_days.gsub("'",'"').gsub('=>',':'))
        @settings.timings = JSON.parse(@settings.timings.gsub("'",'"').gsub('=>',':'))
      end
      @settings
    end
  end

  def update
    days = [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
    on_days = {}
    days.each do |day|
      if params[day].blank?
        on_days[day] = false
      else
        on_days[day] = true
      end
    end
    daily_timings = ['monday_start_time', 'monday_end_time', 'tuesday_start_time',
                'tuesday_end_time', 'wednesday_start_time', 'wednesday_end_time',
                'thursday_start_time', 'thursday_end_time', 'friday_start_time',
                'friday_end_time', 'saturday_start_time', 'saturday_end_time',
                'sunday_start_time', 'sunday_end_time']
    timings = {}
    daily_timings.each do |timing|
      if params[timing].blank?
        timings[timing] = '00:00 AM'
      else
        timings[timing] = params[timing]
      end
    end
    @settings = @settings.first
    @settings.working_days = on_days
    @settings.timings = timings
    @settings.holidays = JSON.parse(params[:holidays].gsub("'",'"').gsub('=>',':'))
    @settings.allocated_leaves = params[:allocated_leaves]
    @settings.attendance_time = params[:attendance_time]
    if @settings.save
      redirect_to settings_path
    else
      redirect_to menus_index_path
    end
  end
end
