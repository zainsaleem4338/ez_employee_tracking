class Event < ActiveRecord::Base
	sequenceid :company , :events
  validates :event_date, presence: true
  validates :title, presence: true
  validates :description, length: { minimun: 0, maximum: 255}
  belongs_to :company
end
