require 'rails_helper'

RSpec.describe Task, type: :model do

  context 'with valid ' do
    let(:task1) {FactoryGirl.create(:task)}
    let(:task2) {FactoryGirl.create(:task,:task_update_invalid_date)}
    let(:task3) {FactoryGirl.create(:task,:task_update_invalid_date_2)}
    let(:task4) {FactoryGirl.create(:task,:task_status_new)}
    let(:task5) {FactoryGirl.create(:task,:task_status_assigned)}

    it "should raise an error" do
      expect{task1}.to raise_error(ActiveRecord::RecordInvalid)
    end
    
    it "should raise error of invalid date start date cannot be later than end date" do 
      expect{task2}.to raise_error(ActiveRecord::RecordInvalid)
    end
    
    it "should raise error of invalid date start date should be greater than today's date" do 
      expect{task3}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should set the status equal to new" do 
      binding.pry
      expect(task4.status).to eq("new")
    end

    it "should set the status equal to assigned" do 
      expect(task5.status).to eq("assigned")
    end

  end
end
