require 'rails_helper'

describe 'Employees' do
  describe 'POST EmployeesController#create' do
    context 'when the employee is build' do
      it 'should return object' do
        employee = FactoryGirl.build(:employee)
        expect(employee).to eq(employee)
      end
    end
    context 'when the employee is created' do
      it 'should return true' do
        binding.pry
        employee = FactoryGirl.create(:employee)
        expect { employee }.should raise_error(StandardError)
        # Instead SequnceID is messing with something
      end
    end
  end
end
