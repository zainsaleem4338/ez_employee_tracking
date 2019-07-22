require 'rails_helper'

RSpec.describe DepartmentsController, type: :controller do
  context 'Test cases for create department' do
    it 'should return object' do
      department = Department.new(name: 'Rails', description: 'Rails department')
      expect(department.save).to be true
    end
    it 'should return false' do
      department = Department.new(name: '', description: 'Rails department')
      expect(department.save).to be false
    end
  end
  context 'Test cases for update department' do
    new_department = Department.create(name: 'Rails', description: 'Rails department')
    it 'should return object' do
      expect(new_department.update(name: 'Ruby on Rails')).to be true
    end
    it 'should return false' do
      expect(new_department.update(name: '')).to be false
    end
  end
end
