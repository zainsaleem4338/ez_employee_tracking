require 'rails_helper'

RSpec.describe Company, type: :model do
  context 'Company creation' do
    it 'should create a Company' do
      company = Company.create(name: 'Techlogix', description: 'A software company')
      expect(company).to be_valid
    end
  end
  context 'with invalid attributes' do
    it 'should not be valid company' do
      company = Company.create(description: 'Blah Blah Blah')
      expect(company).not_to be_valid
    end
  end
end
