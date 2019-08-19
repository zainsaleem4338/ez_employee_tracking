class Event < ActiveRecord::Base
	sequenceid :company , :events
  validates :event_date, presence: true
  validates :title, presence: true
  belongs_to :company
end
