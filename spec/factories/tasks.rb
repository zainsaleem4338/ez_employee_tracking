FactoryGirl.define do
  factory :task do
    name "My new task"
    start_date "25-07-2019"
    end_date "27-07-2019"

    trait :task_update_invalid_date do 
      start_date "25-09-2019"
      end_date "25-08-2019"
      company_id 1
      project_id 2
    end

    trait :task_update_invalid_date_2 do 
      start_date "21-07-2019"
      end_date "25-08-2019"
      company_id 1
      project_id 2
    end

    trait :task_status_new do 
      company_id 1
      project_id 2
      assignable_id 6
      assignable_type "Employee"
    end

    trait :task_status_assigned do 
      company_id 1
      project_id 2
    end
  end
end
