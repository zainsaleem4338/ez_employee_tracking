class Event < ActiveRecord::Base
  validates :event_date, presence: true
  belongs_to :company
end
