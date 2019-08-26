require 'rails_helper'

RSpec.describe Project, type: :model do
  before(:all) do
    company = FactoryGirl.create(:company)
    current_user = FactoryGirl.create(:employee)
  end
  
  context 'Test Cases for create team' do
    let(:project1) { FactoryGirl.create(:project) }
    let(:project2) { FactoryGirl.create(:project, start_date: "01-07-2019") }
    let(:project3) { FactoryGirl.create(:project, start_date: "01-08-2019", expected_end_date: "29-07-2019") }

    it 'should save the project' do
      expect { project1 }.to change { Project.count }.by(1)
    end

    it 'should give error on the basis of wrong start date' do
      expect { project2 }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should give error on the basis of end date before start date' do
      expect { project2 }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
