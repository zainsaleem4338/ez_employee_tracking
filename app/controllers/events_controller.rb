class EventsController < ApplicationController
  load_and_authorize_resource :event, through_association: :company, find_by: :sequence_num
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
      redirect_to home_events_path
    else
      render 'new'
    end
  end

  # patch '/events/:id/update'
  def update
    if @event.update(event_params)
      flash[:success] = t('.success_notice')
      redirect_to home_events_path
    else
      render 'edit'
    end
  end

  # delete '/events/:id/destroy'
  def destroy
    if @event.destroy
      flash[:success] = t('.success_notice')
    else
      flash[:danger] = t('.error_notice')
    end
    redirect_to home_events_path
  end

  def home
    @events = @events.paginate(page: params[:page], per_page: 5)
  end

  protected

  def event_params
    params.require(:event).permit(:title, :description, :event_date)
  end
end
