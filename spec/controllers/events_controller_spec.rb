require 'rails_helper'
require 'support/controller_helpers'

RSpec.describe EventsController, type: :controller do
  before :all do
    @company = build(:company)
    @company.save
  end
  before :all do
    @event = build(:event)
    @event.company_id = @company.id
    @event.save
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
      expect(response).to be_success
    end
  end
  context 'GET #new' do
    it 'render new template successfully' do
      get :new
      expect(response).to render_template('new')
    end
  end
 context 'GET #home' do
    it 'directs to home successfully' do
      get :home
      expect(response).to be_success
    end
  end
  context 'Create Event' do
    it 'should create event successfully' do
      expect(put :create, event:  { id: @event.id, title: @event.title, description: @event.description, event_date: @event.event_date, company_id: @event.company_id}).to be_success
    end
    it 'should not create event successfully' do
      expect(put :create, event: {id: @event.id, title: @event.title, description: @event.description, company_id: @event.company_id}).to eq(false)
    end
    it 'should notcreate event successfully' do
      expect(put :create, event: {id: @event.id, description: @event.description, event_date: @event.event_date, company_id: @event.company_id}).to eq(false)
    end
  end
  context 'GET #edit' do
    it 'render edit template successfully' do
      get :edit, id: @event.id
      expect(response).to render_template('edit')
    end
  end
  context 'Update Event' do
    let(:update_params) { { id: 1, title: 'Convocation', description: 'Event at night', event_date: '10:00 AM', company_id: @company.id } }
    it 'should update the event' do
      expect(put :update, id: @event.id, event: update_params).to redirect_to index_events_path
    end
  end
  context 'Delete Event' do
    it 'should delete the event' do
      expect(delete :destroy, id: @event.id).to redirect_to index_events_path
    end
  end
end
