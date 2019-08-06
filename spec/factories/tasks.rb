FactoryGirl.define do
  factory :task do
    name 'My new task'
    start_date '25-10-2019'
    expected_end_date '29-11-2019'
    project_id 1
    company_id 1
    assignable_type ''
    assignable_id ''

    trait :task_update_invalid_date do
      start_date '25-09-2019'
      expected_end_date '25-08-2019'
    end

    trait :task_update_invalid_date_2 do
      start_date '21-07-2019'
      expected_end_date '25-08-2019'
    end

    trait :task_status_new do
      company_id 1
    end

    trait :task_status_assigned do
      assignable_id 6
      assignable_type 'Employee'
      company_id 1
    end

    association :project, factory: :project
  end
end
