require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) {FactoryBot.create(:task)}

  it "has a valid factory" do
    expect(task).to be_invalid
  end
end
