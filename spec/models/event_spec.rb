require 'rails_helper'

describe 'Event', type: :model do
  context 'event_date should be present' do
    it 'it should be valid' do
      event = Event.create(title: 'Convocation', description: 'Event at night', event_date: '10:00 PM')
      expect(event).to be_valid
    end
    it 'valid without title and description' do
      event = Event.create(event_date: '10:00 PM')
      expect(event).to be_valid
    end
  end
  context 'event_date is not present' do
    it 'should not be valid' do
      event = Event.create(title: 'Convocation', description: 'Event at night')
      expect(event).not_to be_valid
    end
  end
end
