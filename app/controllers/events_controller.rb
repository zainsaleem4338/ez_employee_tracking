class EventsController < ApplicationController
  load_and_authorize_resource

  # get '/events/index'
  def index
    @settings = current_employee.company.setting.holidays
    respond_to do |format|
      format.html
    end
  end

  # post '/events/create'
  def create
    @event.company_id = current_company.id
    if @event.save
      flash[:success] = t('.success_notice')
      redirect_to events_path
    else
      flash[:danger] = t('.error_notice')
      redirect_to menus_index_path
    end
  end

  # patch '/events/:id/update'
  def update
    if @event.update(event_params)
      flash[:success] = t('.success_notice')
      redirect_to events_path
    else
      flash[:danger] = t('.error_notice')
      redirect_to menus_index_path
    end
  end

  # delete '/events/:id/destroy'
  def destroy
    if @event.destroy
      flash[:success] = t('.success_notice')
      redirect_to index_events_path
    else
      flash[:danger] = t('.error_notice')
      redirect_to menus_index_path
    end
  end

  protected

  def event_params
    params.require(:event).permit(:title, :description, :event_date)
  end
end
