FactoryGirl.define do
  factory :employee, class: 'Employee' do |emp|
    sequence(:name) { |n| "Aghaaa#{n}" }
    sequence(:email) { |n| "aghaaa#{n}@gmail.com" }
    emp.password "netmail123"
    emp.role "employee"
    emp.company_id 1
    emp.confirmation_token true
  end
end
