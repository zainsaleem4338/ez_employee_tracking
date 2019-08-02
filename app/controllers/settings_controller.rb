class SettingsController < ApplicationController
  def index
    @settings = Setting.find_by(company_id: current_company.id)
    if @settings.present?
      if(@settings.working_days.class == String)
        @settings.working_days = JSON.parse(@settings.working_days.gsub("'",'"').gsub('=>',':'))
        @settings.timings = JSON.parse(@settings.timings.gsub("'",'"').gsub('=>',':'))
      end
      @settings
    end
  end

  def edit
    @settings = Setting.find_by(company_id: current_company.id)
    if @settings != nil
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
    @setting = Setting.find_by(company_id: current_company.id)
    @setting.working_days = on_days
    @setting.timings = timings
    @setting.holidays = JSON.parse(params[:holidays].gsub("'",'"').gsub('=>',':'))
    @setting.allocated_leaves = params[:allocated_leaves]
    @setting.attendance_time = params[:attendance_time]
    if @setting.save
      redirect_to index_settings_path
    else
      redirect_to menus_index_path
    end
  end

  def destroy
    @settings = Setting.find_by(company_id: current_company.id)
    if @settings.destroy
      redirect_to index_settings_path
    else
      flash[:danger] = 'Settings have not been delete!'
      redirect_to index_settings_path
    end
  end
end
