FactoryGirl.define do
  factory :employee, class: 'Employee' do |emp|
    emp.name "Agha"
    emp.email "agha@gmail.com"
    emp.password "netmail123"
    emp.role "employee"

    association :company, factory: :assoc_company
  end
  factory :assoc_company, class: 'Company' do |comp|
    comp.name "PkEnvisage"
  end
end
