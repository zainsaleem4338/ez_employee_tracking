require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before(:all) do
    @company = Company.create(:name => "7Vals")
    @admin = @company.employees.create(:name => "yolo", :email => "yolo@yolo.com", :password => "helloworld", :role => "Admin")
  end
  before(:each) do
    @department = FactoryGirl.create(:department, company_id: @admin.company_id)
    @project = FactoryGirl.create(:project, company_id: @admin.company_id, department_id: @department.id)
    sign_in @admin
  end
  context 'actions for the admin' do
    it 'should create a task' do
      task_params = FactoryGirl.attributes_for(:task)
      task_params[:company_id] = @admin.company_id
      task_params[:project_id] = @project.id
      params = {
        task: task_params,
        'assignable_employee_id': '',
        'assignable_team_id': '',
        project_id: @project.id
      }
      expect { post :create, params }.to change(Task, :count).by(1)
    end

    it 'should not create a task' do
      task_params = FactoryGirl.attributes_for(:task)
      task_params[:company_id] = @admin.company_id
      task_params[:project_id] = @project.id
      task_params[:start_date] = "26-06-2019"
      params = {
        task: task_params,
        'assignable_employee_id': '',
        'assignable_team_id': '',
        project_id: @project.id
      }
      expect { post :create, params }.to change(Task, :count).by(0)
    end


    it 'should update a task with employee assignable' do
      @task = FactoryGirl.create(:task, project_id: @project.id, company_id: @admin.company_id)
      task_params = @task.attributes
      task_params['assignable_id'] = @admin.id
      task_params['assignable_type'] = 'Employee'
      params = {
        task: task_params,
        'assignable_employee_id': @admin.id,
        'assignable_team_id': '',
        id: @task.id,
        project_id: @project.id
      }
      expect_block = expect do
        put :update, params, id: @task.id, project_id: @project.id
        @task.reload
      end
      expect_block.to change { @task.status }.to("assigned")
    end

    it 'should not update a task with employee and team assignable ids' do
      @task = FactoryGirl.create(:task, project_id: @project.id, company_id: @admin.company_id)
      task_params = @task.attributes
      task_params['assignable_id'] = @admin.id
      task_params['assignable_type'] = 'Employee'
      params = {
        task: task_params,
        'assignable_employee_id': @admin.id,
        'assignable_team_id': @admin.id,
        id: @task.id,
        project_id: @project.id
      }
      expect_block = expect do
        put :update, params, id: @task.id, project_id: @project.id
        @task.reload
      end
      expect_block.not_to change { @task.status }
    end

    it 'should not update a task with wrong start_date' do
      @task = FactoryGirl.create(:task, project_id: @project.id, company_id: @admin.company_id)
      task_params = @task.attributes
      task_params['start_date'] = "26-06-2019"
      task_params['assignable_id'] = ''
      task_params['assignable_type'] = 'Employee'
      params = {
        task: task_params,
        'assignable_employee_id': '',
        'assignable_team_id': '',
        id: @task.id,
        project_id: @project.id
      }
      expect_block = expect do
        put :update, params, id: @task.id, project_id: @project.id
        @task.reload
      end
      expect_block.not_to change { @task.start_date }
    end

    it 'should destroy the task' do
      @task = FactoryGirl.create(:task, project_id: @project.id, company_id: @admin.company_id)
      expect { delete :destroy, id: @task.id, project_id: @project.id }.to change(Task, :count).by(-1)
    end

    it 'should update status' do
      @task = FactoryGirl.create(:task, project_id: @project.id, company_id: @admin.company_id)
      task_params = @task.attributes
      task_params['assignable_id'] = @admin.id
      task_params['assignable_type'] = 'Employe'
      task_params['status'] = "reviewready"
      params = {
        task: task_params,
        'assignable_employee_id': @admin.id,
        'assignable_team_id': '',
        id: @task.id,
        project_id: @project.id
      }
      expect_block = expect do
        put :update_status, params, id: @task.id, project_id: @project.id
        @task.reload
      end
      expect_block.to change { @task.status }.to("reviewready")
    end
  end
end
