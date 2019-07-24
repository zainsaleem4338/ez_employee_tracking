require 'rails_helper'

describe 'Company' do
  describe 'POST Company#create' do
    context 'Company name should be unique' do
      it 'it should return error' do
        FactoryGirl.create(:company)
        expect { FactoryGirl.create(:company) }.to raise_error(ActiveRecord::RecordInvalid)
      end
      it 'it should return error' do
        company = Company.new
        company.name = 'B'
        expect(company.save).to eq(false)
      end
    end
  end
end
