FactoryGirl.define do
  factory :employee, class: 'Employee' do |emp|
    sequence(:name) {|n| "Aghaaa#{n}"}
    sequence(:email) {|n| "aghaaa#{n}@gmail.com"}
    emp.password "netmail123"
    emp.role "Employee"

    association :company, factory: :assoc_company
  end

  factory :admin, class: 'Employee' do |emp|
    sequence(:name) {|n| "Aaa#{n}"}
    sequence(:email) {|n| "aaa#{n}@gmail.com"}
    emp.password "netmail123"
    emp.role "Admin"

    association :company, factory: :assoc_company
  end


  factory :assoc_company, class: 'Company' do |comp|
    comp.name "PkEnvisage"
  end
end
