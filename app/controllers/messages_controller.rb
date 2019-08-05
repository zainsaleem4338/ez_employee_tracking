class MessagesController < ApplicationController
  def index
    @message = current_company.messages.new
    @messages = current_company.messages
  end

  def create
    @message = Message.create!(params.require(:message).permit([:message, :employee_id, :company_id]))
  end
end