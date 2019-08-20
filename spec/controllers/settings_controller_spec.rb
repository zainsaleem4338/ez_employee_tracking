require 'rails_helper'
require 'support/controller_helpers'

RSpec.describe SettingsController, type: :controller do
  before :all do
    @company = build(:company)
    @company.save
  end
  before :all do
    @setting = build(:setting)
    @setting.company_id = @company.id
    @setting.save
  end
  before :all do
    @employee = build(:employee)
    @employee.company_id = @company.id
    @employee.save
    @employee.confirm!
  end

  before(:each) do
    mock_subdomain = @company.subdomain
    @request.host = "#{mock_subdomain}.example.com"
  end

  before :each do
    sign_in @employee
  end

  context 'GET #index' do
    it 'directs to index successfully' do
      get :index
      expect(response).to render_template('index')
    end
  end
  context 'GET #edit' do
    it 'render edit template successfully' do
      get :edit, id: @setting.id
      expect(response).to render_template('edit')
    end
  end
  context 'Update Event' do
    it 'should update the settings' do
      expect(put :update, id: @setting.id, working_days: @setting.working_days, timings: @setting.timings, holidays: @setting.holidays, task_alert: @setting.task_alert, allocated_leaves: @setting.allocated_leaves, attendance_time: @setting.attendance_time).to redirect_to settings_path
    end
    it 'should update the settings with working_days, timings and holidays' do
      expect(put :update, id: @setting.id, working_days: @setting.working_days, timings: @setting.timings, holidays: @setting.holidays).to redirect_to settings_path
    end
  end
end
