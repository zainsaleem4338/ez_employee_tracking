class Event < ActiveRecord::Base
  validates :event_date, presence: true
  validates :title, presence: true
  belongs_to :company
end
