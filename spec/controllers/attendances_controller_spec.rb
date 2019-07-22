require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do
  context 'GET attendance record' do
    it 'directs to attendance record seccessfully' do
      session[:current_company_id] = 1
      get :index
      expect(response).to be_success
    end
  end
end
