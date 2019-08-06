require 'rails_helper'
require 'support/controller_helpers'

RSpec.describe EventsController, type: :controller do
  before :all do
    @company = build(:company)
    @company.save
  end
  before :all do
    @event = build(:event)
    @event.save
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

  let(:event) { create(:event) }
  let(:event_params) { { id: 1, title: 'Convocation', description: 'Event at night', event_date: '10:00 AM', company_id: @company.id } }

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
    let(:event_params1) { { title: 'Convocation', description: 'Event at night', company_id: @company.id } }
    let(:event_params2) { { event_date: '10:00 AM' } }
    it 'should create event successfully' do
      expect { post :create, event: event_params }.to change(Event, :count).by(1)
    end
    it 'should not create event' do
      expect { post :create, event: event_params1 }.to change(Event, :count).by(0)
    end
    it 'should create event just by date' do
      expect { post :create, event: event_params2 }.to change(Event, :count).by(1)
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
