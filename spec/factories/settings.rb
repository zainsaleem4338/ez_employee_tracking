FactoryGirl.define do
  factory :setting, :class => 'Setting' do |f|
    f.id 1
    f.working_days '{ "monday" => true, "tuesday" => true, "wednesday" => true, "thursday" => true, "friday" => true, "saturday" => true, "sunday" => true}'
    f.timings '{ "monday_start_time" => "00:00 AM", "monday_end_time" => "00:00 AM", "tuesday_start_time" => "00:00 AM", "tuesday_end_time" => "00:00 AM", "wednesday_start_time" => "00:00 AM", "wednesday_end_time" => "00:00 AM", "thursday_start_time" => "00:00 AM", "thursday_end_time" => "00:00 AM", "friday_start_time" => "00:00 AM", "friday_end_time" => "00:00 AM", "saturday_start_time" => "00:00 AM", "saturday_end_time" => "00:00 AM", "sunday_start_time" => "00:00 AM", "sunday_end_time" => "00:00 AM" }'
    f.holidays "{\"1\":{\"holiday_date_1\":\"2019-08-07\",\"every_year_1\":true}}"
    f.allocated_leaves 5
    f.task_alert 1
    f.attendance_time 30
  end
end
