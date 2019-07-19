FactoryGirl.define do
  factory :employee, :class => 'Employee' do |f|
    f.name "Agha"
    f.email "agha@gmail.com"
    f.password "netmail123"
    f.role "employee"

    association :company, factory: :assoc_company  ## set association
  end
  
  factory :assoc_company, :class => 'Company' do |f|
    ## assign fields
    f.name "PkEnvisage"
  end
end
