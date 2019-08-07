class MessagesController < ApplicationController
  load_and_authorize_resource

  # get '/messages/index'
  def index
    @message = current_company.messages.new
    respond_to do |format|
      format.html
    end
  end

  # post '/messages/'
  def create
    @message = Message.create!(create_params)
  end

  def create_params
    params.require(:message).permit([:message, :employee_id, :company_id])
  end
end
