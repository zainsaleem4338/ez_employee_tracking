class MessagesController < ApplicationController  
  def index
    @messages = current_company.messages
  end

  def create
    @message = Message.create!(params.require(:message).permit([:message, :employee_id, :company_id]))
  end
end