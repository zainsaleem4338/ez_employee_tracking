FactoryGirl.define do
  factory :employee, class: 'Employee' do |emp|
    sequence(:name) { |n| "Aghaaa#{n}" }
    sequence(:email) { |n| "aghaaa#{n}@gmail.com" }
    emp.password "netmail123"
    emp.role Employee::ADMIN_ROLE
    emp.company_id 1
    emp.confirmation_token true
  end
  factory :employee1, class: 'Employee' do |emp|
    sequence(:name) { |n| "Sumbal#{n}" }
    sequence(:email) { |n| "sumbaltariq#{n}@gmail.com" }
    emp.password "netmail123"
    emp.role "employee"
    emp.company_id 1
    emp.confirmation_token true
  end
  factory :employee2, class: 'Employee' do |emp|
    sequence(:name) { |n| "Tehreem#{n}" }
    sequence(:email) { |n| "tehreemfatima#{n}@gmail.com" }
    emp.password "netmail123"
    emp.role "employee"
    emp.company_id 1
    emp.confirmation_token true
  end
end
