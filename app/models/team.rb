class Team < ActiveRecord::Base
  has_many :tasks, :as => :assignable
  belongs_to :company
end
