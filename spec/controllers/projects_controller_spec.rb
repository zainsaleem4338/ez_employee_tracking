require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  before(:each) do
    @employee = FactoryGirl.create(:employee, role: 'Admin')
    @department = FactoryGirl.create(:department, company_id: @employee.company_id)
    sign_in @employee
  end

  context 'when the user is admin' do
    it 'should create a project' do
      project_params = FactoryGirl.attributes_for(:project)
      project_params[:company_id] = @employee.company_id
      project_params[:department_id] = @department.id
      expect { post :create, project: project_params }.to change(Project, :count).by(1)
    end

    it 'should not create a project' do
      project_params = FactoryGirl.attributes_for(:project_without_start_date)
      project_params[:company_id] = @employee.company_id
      project_params[:department_id] = @department.id
      expect { post :create, project: project_params }.to change(Project, :count).by(0)
    end

    it 'should update the project' do
      @project = FactoryGirl.create(:project, company_id: @employee.company_id, department_id: @department.id)
      project_params = @project.attributes
      project_params['name'] = 'newproj'
      expect_block = expect do
        put :update, project: project_params, id: @project.id
        @project.reload
      end
      expect_block.to change { @project.name }.to('newproj')
    end

    it 'should not update the project' do
      @project = FactoryGirl.create(:project, company_id: @employee.company_id, department_id: @department.id)
      project_params = @project.attributes
      project_params['start_date'] = '27-06-2019'
      expect_block = expect do
        put :update, project: project_params, id: @project.id
        @project.reload
      end
      expect_block.not_to change { @project.start_date }
    end

    it 'should destroy the task' do
      @project = FactoryGirl.create(:project, company_id: @employee.company_id, department_id: @department.id)
      expect { delete :destroy, id: @project.id }.to change(Project, :count).by(-1)
    end
  end
end
