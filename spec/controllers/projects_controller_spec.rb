require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  before(:all) do
    @company = build(:company)
    @company.save
    @employee = build(:employee)
    @employee.company_id = @company.id
    @employee.save
    @employee.confirm!
  end

  before(:each) do
    @department = FactoryGirl.create(:department, company_id: @employee.company_id)
    sign_in @employee
  end

  context 'when the user is admin' do
    it 'should create a project' do
      project_params = FactoryGirl.attributes_for(:project)
      project_params[:company_id] = @employee.company_id
      project_params[:department_id] = @department.id
      post :create, project: project_params, department_id: @department.id
      expect(response).to have_http_status(302)
    end

    it 'should not create a project' do
      project_params = FactoryGirl.attributes_for(:project_without_start_date)
      project_params[:company_id] = @employee.company_id
      project_params[:department_id] = @department.id
      post :create, :project => project_params, department_id: @department.id
      expect(response).to have_http_status(302)
    end

    it 'should update the project' do
      @project = FactoryGirl.create(:project, company_id: @employee.company_id, department_id: @department.id)
      project_params = @project.attributes
      project_params["name"] = "newproj"
      put :update, project_params, id: @project.id, department_id: @department.id
      @project.reload
      @project.name.should eql "newproj"
    end

    it 'should not update the project' do
      @project = FactoryGirl.create(:project, company_id: @employee.company_id, department_id: @department.id)
      project_params = @project.attributes
      project_params['start_date'] = '27-06-2019'
      expect_block = expect do
        put :update, project: project_params, id: @project.id, department_id: @department.id
        @project.reload
      end
      expect_block.not_to change { @project.start_date }
    end

    it 'should destroy the task' do
      @project = FactoryGirl.create(:project, company_id: @employee.company_id, department_id: @department.id)
      expect(delete :destroy, id: @project.id, department_id: @department.id).to redirect_to department_projects_path
    end
  end
end
