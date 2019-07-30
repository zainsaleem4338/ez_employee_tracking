require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before(:each) do
    @admin = FactoryGirl.create(:admin)
    @employee = FactoryGirl.create(:employee)
    @department = FactoryGirl.create(:department, company_id: @admin.company_id)
    @project = FactoryGirl.create(:project, company_id: @admin.company_id, department_id: @deppartment.id)
    @task = FactoryGirl.create(:task, project_id: @project.id, company_id: @admin.company_id)
    sign_in @admin
  end
  context 'actions for the admin' do
    it 'should create a task' do
      task_params = @task.attributes
      task_params['assignable_employee_id'] = ''
      task_params['assignable_team_id'] = ''
      expect { post :create, task: task_params }.to change(Task, :count).by(1)
    end

    it 'should update a task with employee assignable' do
      task_params = @task.attributes
      task_params['assignable_employee_id'] = @employee.id
      task_params['assignable_employee_type'] = 'Employee'
      task_params['assignable_team_id'] = ''
      expect_block = expect do
        put :update, task: task_params, id: @task.id, project_id: @project.id
        @task.reload
      end
      expect_block.to change { @task.status }.to(Task::ASSINGED_STATUS)
    end
  end
end
