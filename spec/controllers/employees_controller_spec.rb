require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  context 'with invalid attributes' do
    it 'should not be valid contact' do
      employee = Employee.create(email: 'tehreem@7valscom', password: '123456')
      expect(employee).not_to be_valid
    end
  end
  context 'with valid attributes' do
    it 'create new contact' do
      employee = Employee.create(email: 'tehreem.talat@7vals.com', password: 'tehreem')
      expect(employee).to be_valid
    end
  end

  context 'GET #index' do
    it 'directs to index seccessfully' do
      get :index
      expect(response).to be_success
    end
  end
end
