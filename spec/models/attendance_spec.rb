require "rails_helper"

RSpec.describe Attendance, type: :model do
  before(:all) do
    company = FactoryGirl.create(:company)
    @employee = FactoryGirl.create(:employee)
  end

  context 'validations' do
    let(:attendance1) { FactoryGirl.create(:attendance, employee_id: @employee.id) }
    let(:attendance2) { FactoryGirl.create(:attendance, employee_id: @employee.id) }
    
    it { is_expected.to validate_presence_of(:login_time) }
    it { is_expected.to validate_presence_of(:employee_id) }
  end

  context 'with valid attributes' do
    let(:attendance3) { FactoryGirl.create(:attendance, employee_id: @employee.id) }
    it 'should create an Attendance' do
      expect(attendance3).to be_valid
    end
  end

  context 'with invalid attributes' do
    let(:attendance4) { FactoryGirl.build(:attendance, login_time: DateTime.now, status: 'present', employee_id: @employee.id) }
    let(:attendance5) { FactoryGirl.build(:attendance, login_time: DateTime.now, status: 1, employee_id: nil) }

    it 'should not be valid attendance' do
      expect{ attendance4.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
    it 'should not be valid attendance' do
      expect{ attendance5.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
