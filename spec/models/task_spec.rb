require 'rails_helper'
require 'date'

RSpec.describe Task, type: :model do
  before(:each) do
    @company = Company.create(name: '7Vals', description: 'A Saas company')
    @department = @company.departments.create(name: "UX dept")
    @project = @company.projects.create(name: "CS proj", start_date: "2019-09-09", expected_end_date: "2019-09-10", department_id: @department.id)
    @employee = @company.employees.create(name: "Qasim", email: "qasim@qasim.com", password: "helloworld", role: "Employee")
  end

  context 'validations' do
    it "should not raise an error: Task created successfully" do
      @task = @project.tasks.create(name: "Task 1", start_date: "2019-09-09", expected_end_date: "2019-10-08", company_id: @company.id)
      expect(@task).to be_valid
    end

    it "should raise an error: Start Date cannot be before than today" do
      @task = @project.tasks.create(name: "Task 1", start_date: "2019-07-09", expected_end_date: "2019-10-08", company_id: @company.id)
      expect(@task).not_to be_valid
    end

    it "should raise an error: End date cannot be before start date" do
      @task = @project.tasks.create(name: "Task 1", start_date: "2019-09-09", expected_end_date: "2019-09-08", company_id: @company.id)
      expect(@task).not_to be_valid
    end
  end

  context 'checking the status' do
    it "should set the status equal to new" do
      @task = @project.tasks.create(name: "Task 1", start_date: "2019-09-09", expected_end_date: "2019-10-08", company_id: @company.id)
      @task.set_status
      expect(@task.status).to eq(Task::NEW_STATUS)
    end

    it "should set the status equal to assigned" do
      @task = @project.tasks.create(name: "Task 1", start_date: "2019-09-09", expected_end_date: "2019-10-08", company_id: @company.id, assignable: @employee)
      @task.set_status
      expect(task5.status).to eq(Task::ASSIGNED_STATUS)
    end
  end
end
