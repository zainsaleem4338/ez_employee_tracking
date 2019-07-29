class SettingsController < ApplicationController
  def index
    @settings = Setting.find_by(company_id: current_company.id)
  end

  def new
    @setting = Setting.find_by(company_id: current_company.id)
  end

  def create
    days = [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
    on_days = {}
    days.each do |day|
      if params[day].blank?
        on_days[day] = false
      else
        on_days[day] = true
      end
    end
    @setting = Setting.new
    @setting.company_id = current_company.id
    @setting.working_days = on_days
    if @setting.save
      redirect_to index_settings_path
    else
      redirect_to menus_index_path
    end
  end

  def edit
    @settings = Setting.find_by(company_id: current_company.id)
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
    @setting = Setting.find_by(company_id: current_company.id)
    @setting.working_days = on_days
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
