class MessagesController < ApplicationController
  load_and_authorize_resource
  def index
    @message = current_company.messages.new
  end

  def create
    @message = Message.create!(create_params)
  end

  def create_params
    params.require(:message).permit([:message, :employee_id, :company_id])
  end
end
