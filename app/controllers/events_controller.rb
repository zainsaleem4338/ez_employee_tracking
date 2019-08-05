class EventsController < ApplicationController
  def index
    @events = []
    @event = current_employee.company.events
    @setting = current_employee.company.setting.holidays
    @events << @event
    @events << @setting
  end

  def new
    @event = current_employee.company.events.new
  end

  def home
    @events = current_employee.company.events
  end

  def create
    @event = Event.unscoped.new(event_params)
    @event.company_id = current_company.id
    if @event.save
      flash[:success] = 'Event has been added!'
      redirect_to index_events_path
    else
      flash[:danger] = 'Event has not been added!'
      redirect_to menus_index_path
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      flash[:success] = 'Event has been updated!'
      redirect_to index_events_path
    else
      flash[:danger] = 'Event has not been updated!'
      redirect_to menus_index_path
    end
  end

  def destroy
    @event = Event.find(params[:id])
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
