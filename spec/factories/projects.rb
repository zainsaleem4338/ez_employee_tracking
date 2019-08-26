FactoryGirl.define do
  factory :project, class: 'Project' do |project|
    project.name "CS Proj"
    project.start_date "27-08-2019"
    project.expected_end_date "27-09-2019"
    department_id 1
    company_id 1

    association :department, factory: :department
  end
  factory :project_without_start_date, class: 'Project' do |project|
    project.name "CS Proj"
    project.expected_end_date "27-09-2019"
    project.start_date "27-06-2019"
    department_id 1
    company_id 1

    association :department, factory: :department
  end
end
