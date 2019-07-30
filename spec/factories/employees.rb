FactoryGirl.define do
  factory :employee, class: 'Employee' do |emp|
    emp.name "Aghaa"
    emp.email "aghaa@gmail.com"
    emp.password "netmail123"
    emp.role "Employee"

    association :company, factory: :assoc_company
  end

    factory :admin, class: 'Employee' do |emp|
    emp.name "Aghaaa"
    emp.email "aghaaa@gmail.com"
    emp.password "netmail123"
    emp.role "Admin"

    association :company, factory: :assoc_company
  end

  factory :assoc_company, class: 'Company' do |comp|
    comp.name "PkEnvisage"
  end
end
