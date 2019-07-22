require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do
  before(:each) do
    @employee = Employee.create!(email:'ishi@gmail.com', password:'ishi', company_id: 2)
  end
  context 'Mark attendance' do
    it 'marks the employee present' do
      get :index
      get :create
      response.code.should.eq '200'
      expect(response).to be_success
    end
  end

  context 'GET attendance record' do
    it 'directs to attendance record seccessfully' do
      get :index
      expect(response).to be_success
    end
  end
end
