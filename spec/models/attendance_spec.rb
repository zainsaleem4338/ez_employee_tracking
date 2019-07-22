require 'rails_helper'

RSpec.describe Attendance, type: :model do

  before(:each) do
    @company = Company.create(name: '7Vals', description: 'A Saas company')
    @employee = @company.employees.create(email: 'zainsaleem@gmail.com', password: 'password')
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:login_time) }
    it { is_expected.to validate_presence_of(:employee_id) }
  end

  context 'with valid attributes' do
    it 'should create an Attendance' do
      result = @company.attendances.create(login_time: DateTime.now, status: 1, employee_id: @employee.id)
      expect(result).to be_valid
    end
  end
  
  context 'with invalid attributes' do
    it 'should not be valid attendance' do
      result = @company.attendances.create(login_time: DateTime.now, status: 'present', employee_id: @employee.id)
      expect(result).not_to be_valid
    end
    it 'should not be valid attendance' do
      result = @company.attendances.create(login_time: DateTime.now, status: 1, employee_id: nil)
      expect(result).not_to be_valid
    end
  end
end
