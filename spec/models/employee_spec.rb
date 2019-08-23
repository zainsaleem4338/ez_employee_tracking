require 'rails_helper'

RSpec.describe Employee, type: :model do
  before(:all) do
    @company = Company.create(name: '7Vals', description: 'A Saas Company')
    @employee = @company.employees.create(email: 'tehreem.talat@7vals.com', password: 'tehreem')
  end

  context 'with valid attributes' do
    it { is_expected.to validate_presence_of(:email) }
    # it { is_expected.to validate_presence_of(:password) }
  end
end
