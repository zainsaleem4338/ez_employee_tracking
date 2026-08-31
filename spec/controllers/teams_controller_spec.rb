require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  before :all do
    @company = build(:company)
    @company.save
    @department = build(:department)
    @department.company_id = @company.id
    @department.save
  end
  before(:all) do
    @employee = build(:employee)
    @employee.company_id = @company.id
    @employee.save
    @employee.confirm!
    @team_leader = build(:employee1)
    @team_leader.company_id = @company.id
    @team_leader.save
    @team_leader.confirm!
    @team_member = build(:employee2)
    @team_member.company_id = @company.id
    @team_member.save
    @team_member.confirm!
  end
  before(:each) do
    mock_subdomain = @company.subdomain
    @request.host = "#{mock_subdomain}.example.com"
  end
  before :each do
    sign_in @employee
    Company.current_id = @company.id
  end
  context 'Test Cases for create team' do
    it 'should create a team' do
      team_params = FactoryGirl.attributes_for(:team)
      team_params[:company_id] = @employee.company_id
      team_params[:employee_teams_attributes] = { "0": { employee_id: @team_leader.id, employee_type: 'Team Leader' },
      "1": { employee_id: @team_member.id, employee_type: 'Team Member' } }
      team_params[:department_id] = @department.id
      expect { post :create, team: team_params, department_id: @department.id }.to change(Team.unscoped, :count).by(1)
    end
    it 'should not create a team' do
      team_params = FactoryGirl.attributes_for(:team)
      team_params[:employee_teams_attributes] = { "0": { employee_id: '', employee_type: 'Team Leader' },
      "1": { employee_id: @team_member.id, employee_type: 'Team Member' } }
       team_params[:department_id] = @department.id
      expect { post :create, team: team_params, department_id: @department.id }.to change(Team, :count).by(0)
    end
    it 'should not create a team' do
      team_params = FactoryGirl.attributes_for(:team)
      team_params[:employee_teams_attributes] = { "0": { employee_id: @team_leader.id, employee_type: 'Team Leader' },
      "1": { employee_id: '', employee_type: 'Team Member' } }
       team_params[:department_id] = @department.id
      expect { post :create, team: team_params, department_id: @department.id }.to change(Team, :count).by(0)
    end
    it 'should not create a team' do
      team_params = FactoryGirl.attributes_for(:team_without_name)
      team_params[:employee_teams_attributes] = { "0": { employee_id: @team_leader.id, employee_type: 'Team Leader' },
      "1": { employee_id: @team_member.id, employee_type: 'Team Member' } }
       team_params[:department_id] = @department.id
      expect { post :create, team: team_params, department_id: @department.id }.to change(Team, :count).by(0)
    end
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
