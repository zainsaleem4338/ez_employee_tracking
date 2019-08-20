FactoryGirl.define do
  factory :team, class: 'Team' do |new_team|
    new_team.name 'Zain Team'
    new_team.description 'This is our new team'
    employee = FactoryGirl.build(:employee)
    department = FactoryGirl.create(:department)
    new_team.company_id employee.company_id
    new_team.department_id department.id
  end
end
