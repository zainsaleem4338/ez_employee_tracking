require 'rails_helper'

RSpec.describe Employee, type: :model do
  before(:each) do
    @company = Company.create(name: '7Vals', description: 'A Saas Company')
    @employee = @company.employees.create(email: 'tehreem.talat@7vals.com', password: 'tehreem')
  end

  context 'with valid attributes' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  context 'with invalid attributes' do
    it 'should not be valid employee' do
      invalid_employee = Employee.create(email: 'tehreem@7valscom', password: '123456')
      expect(invalid_employee).not_to be_valid
    end
    it 'should not be valid employee' do
      invalid_employee = Employee.create(email: 'tehreem@7vals.com', password: '12')
      expect(invalid_employee).not_to be_valid
    end
  end
  
  context 'with valid attributes' do
    it 'create new employee' do
      expect(@employee).to be_valid
    end
  end
end
