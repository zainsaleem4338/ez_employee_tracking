class EventsController < ApplicationController
  load_and_authorize_resource

  def index
    @settings = current_employee.company.setting.holidays
  end

  def create
    @event.company_id = current_company.id
    if @event.save
      flash[:success] = 'Event has been added!'
      redirect_to index_events_path
    else
      flash[:danger] = 'Event has not been added!'
      redirect_to menus_index_path
    end
  end

  def update
    if @event.update(event_params)
      flash[:success] = 'Event has been updated!'
      redirect_to index_events_path
    else
      flash[:danger] = 'Event has not been updated!'
      redirect_to menus_index_path
    end
  end

  def destroy
    if @event.destroy
      flash[:success] = 'Event has been updated!'
      redirect_to index_events_path
    else
      flash[:danger] = 'Event has not been delete!'
      redirect_to menus_index_path
    end
  end

  protected

  def event_params
    params.require(:event).permit(:title, :description, :event_date)
  end
end
