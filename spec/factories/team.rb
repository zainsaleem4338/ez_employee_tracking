FactoryGirl.define do
  factory :team, class: 'Team' do |new_team|
    new_team.name 'Zain Team'
    new_team.description 'This is our new team'
  end
  factory :team_without_name, class: 'Team' do |new_team|
    new_team.name ''
    new_team.description 'This is our new team'
  end
end
