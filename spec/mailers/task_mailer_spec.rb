require "rails_helper"

RSpec.describe TaskMailer, type: :mailer do
  describe "assign_task_notify" do
    let(:mail) { TaskMailer.assign_task_notify }

    it "renders the headers" do
      expect(mail.subject).to eq("Assign task notify")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
