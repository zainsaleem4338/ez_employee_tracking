class SettingsController < ApplicationController
  load_and_authorize_resource

  # get '/settings/index'
  def index
    @settings = @settings.first
    if @settings.present?
      if(@settings.working_days.class == String)
        @settings.working_days = JSON.parse(@settings.working_days.gsub("'",'"').gsub('=>',':'))
        @settings.timings = JSON.parse(@settings.timings.gsub("'",'"').gsub('=>',':'))
      end
      @settings
    end
    respond_to do |format|
      format.html
    end
  end

  # patch '/settings/edit'
  def edit
    @setting = current_employee.company.setting
    if @setting.present?
      if(@setting.working_days.class == String)
        @setting.working_days = JSON.parse(@setting.working_days.gsub("'",'"').gsub('=>',':'))
        @setting.timings = JSON.parse(@setting.timings.gsub("'",'"').gsub('=>',':'))
      end
      @setting
    end
    respond_to do |format|
      format.html
    end
  end

  # get '/settings/update'
  def update
    @setting = current_employee.company.setting
    on_days = Setting.on_days(params)
    timings = Setting.daily_timings(params)
    @setting.working_days = on_days
    @setting.timings = timings
    @setting.task_alert = params[:task_alert]
    @setting.holidays = JSON.parse(params[:holidays].gsub("'",'"').gsub('=>',':'))
    @setting.allocated_leaves = params[:allocated_leaves]
    @setting.attendance_time = params[:attendance_time]
    if @setting.save
      redirect_to settings_path
    else
      redirect_to menus_index_path
    end
  end
end
