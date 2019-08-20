require 'rails_helper'

RSpec.describe Team, type: :model do
  before(:all) do
    @company = build(:company)
    @company.save
    @team_leader = build(:employee1)
    @team_leader.company_id = @company.id
    @team_leader.save
    @team_leader.confirm!
    @team_member = build(:employee2)
    @team_member.company_id = @company.id
    @team_member.save
    @team_member.confirm!
  end
  context 'Test Cases for create team' do
    it 'should create a team' do
      team_params = FactoryGirl.attributes_for(:team)
      team_params[:employee_teams_attributes] = { "0": { employee_id: @team_leader.id, employee_type: 'Team Leader' },
      "1": { employee_id: @team_member.id, employee_type: 'Team Member' } }
      expect { post :create, team: team_params }.to change(Team, :count).by(1)
    end
    # it 'should return false' do
    #   expect(team.create_team('', [3], department.id)).to be false
    # end
    # it 'should return false' do
    #   team.name = ''
    #   expect(team.create_team('2', [3], department.id)).to be false
    # end
    # it 'should return false' do
    #     expect(team.create_team('2', [], department.id)).to be false
    # end
    # it 'should return false' do
    #   expect(team.create_team('', [], department.id)).to be false
    # end
    # it 'should return false' do
    #   team.name = ''
    #   expect(team.create_team('', [], department.id)).to be false
    # end
    # it 'should return false' do
    #   team.name = ''
    #   expect(team.create_team('2', [], department.id)).to be false
    # end
    # it 'should return false' do
    #   team.name = ''
    #   expect(team.create_team('', [], department.id)).to be false
    # end
  end

  # context 'Test Cases for update team' do
  #   department = Department.create(name: 'Computer Science', description: 'CS')
  #   new_team = Team.create(name: 'the Zain Team', department_id: department.id)
  #   update_params = { name: 'Zain team', description: 'This is our team' }
  #   it 'should return object' do
  #     expect(new_team.update_team('2', [3], update_params)).to eql true
  #   end
  #   it 'should return false' do
  #     expect(new_team.update_team('2', [], update_params)).to be false
  #   end
  #   it 'should return false' do
  #     expect(new_team.update_team('', [], update_params)).to be false
  #   end
  #   it 'should return false' do
  #     update_params = { name: '', description: 'This is our team' }
  #     expect(new_team.update_team('', [3], update_params)).to be false
  #   end
  #   it 'should return false' do
  #     update_params = { name: '', description: 'This is our team' }
  #     expect(new_team.update_team('2', [], update_params)).to be false
  #   end
  #   it 'should return false' do
  #     update_params = { name: '', description: 'This is our team' }
  #     expect(new_team.update_team('', [], update_params)).to be false
  #   end
  #   it 'should return false' do
  #     expect(new_team.update_team('', [3], update_params)).to be false
  #   end
  #   it 'should return false' do
  #     update_params = { name: '', description: 'This is our team' }
  #     expect(new_team.update_team('2', [3], update_params)).to be false
  #   end
  # end
end
