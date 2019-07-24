require 'rails_helper'

RSpec.describe Team, type: :model do
  department = Department.create(name: 'Computer Science', description: 'CS')
  team = Team.new(name: 'Zain Team', description: 'This is our team', department_id: department.id)
  context 'Test Cases for create team' do
    it 'should return object' do
      expect(team.create_team('2', '3')).to eql team
    end
    it 'should return false' do
      expect(team.create_team('', '3')).to be false
    end
    it 'should return false' do
      team.name = ''
      expect(team.create_team('2', '3')).to be false
    end
    it 'should return false' do
      expect(team.create_team('2', '')).to be false
    end
    it 'should return false' do
      expect(team.create_team('', '')).to be false
    end
    it 'should return false' do
      team.name = ''
      expect(team.create_team('', '3')).to be false
    end
    it 'should return false' do
      team.name = ''
      expect(team.create_team('2', '')).to be false
    end
    it 'should return false' do
      team.name = ''
      expect(team.create_team('', '')).to be false
    end
  end

  context 'Test Cases for update team' do
    department = Department.create(name: 'Computer Science', description: 'CS')
    new_team = Team.create(name: 'the Zain Team', department_id: department.id)
    update_params = { name: 'Zain team', description: 'This is our team' }
    it 'should return object' do
      expect(new_team.update_team('2', '3', update_params)).to eql new_team
    end
    it 'should return false' do
      expect(new_team.update_team('2', '', update_params)).to be false
    end
    it 'should return false' do
      expect(new_team.update_team('', '', update_params)).to be false
    end
    it 'should return false' do
      update_params = { name: '', description: 'This is our team' }
      expect(new_team.update_team('', '3', update_params)).to be false
    end
    it 'should return false' do
      update_params = { name: '', description: 'This is our team' }
      expect(new_team.update_team('2', '', update_params)).to be false
    end
    it 'should return false' do
      update_params = { name: '', description: 'This is our team' }
      expect(new_team.update_team('', '', update_params)).to be false
    end
    it 'should return false' do
      expect(new_team.update_team('', '3', update_params)).to be false
    end
    it 'should return false' do
      update_params = { name: '', description: 'This is our team' }
      expect(new_team.update_team('2', '3', update_params)).to be false
    end
  end
end
