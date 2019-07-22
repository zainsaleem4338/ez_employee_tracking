require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  context 'GET #index' do
    it 'directs to index seccessfully' do
      get :index
      expect(response).to be_success
    end
  end
end
