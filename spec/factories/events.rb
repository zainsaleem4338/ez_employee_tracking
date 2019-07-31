FactoryGirl.define do
  factory :event, :class => 'Event' do |f|
    f.id 1
    f.title "New Event"
    f.description "Amazing Event"
    f.event_date "10:00 AM"
  end
end
