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
  context 'GET #new' do
    it 'render new template successfully' do
      get :new
      expect(response).to render_template('new')
    end
  end
  context 'Create Setting' do
    let(:setting_params1) { { working_days: @setting.working_days, timings: @setting.timings } }
    it 'should create settings successfully' do
      expect { post :create, setting: setting_params1 }.to change(Setting, :count).by(1)
    end
    it 'should create with default settings' do
      expect { post :create }.to change(Setting, :count).by(1)
    end
  end
  context 'GET #edit' do
    it 'render edit template successfully' do
      get :edit, id: @setting.id
      expect(response).to render_template('edit')
    end
  end
  context 'Update Event' do
    let(:update_params) { { id: 1, working_days: @setting.working_days, timings: @setting.timings, company_id: @setting.company_id } }
    it 'should update the settings' do
      expect(put :update, id: @setting.id, event: update_params).to redirect_to settings_path
    end
  end
  context 'Delete Event' do
    it 'should delete the event' do
      expect(delete :destroy, id: @setting.id).to redirect_to settings_path
    end
  end
end
