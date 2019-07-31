FactoryGirl.define do
  factory :employee, class: 'Employee' do |emp|
    sequence(:name) {|n| "Aghaaa#{n}"}
    sequence(:email) {|n| "aghaaa#{n}@gmail.com"}
    emp.password "netmail123"
    emp.role "Employee"
    emp.company_id 1

  end
end
