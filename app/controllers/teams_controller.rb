class TeamsController < ApplicationController
  load_and_authorize_resource :department, except: [:teams_list, :team_members]
  load_and_authorize_resource through: :department, except: [:teams_list, :team_members]
  load_and_authorize_resource :team, through_association: :company, only: [:teams_list, :team_members]

  # post /departments/:department_id/teams
  def create
    respond_to do |format|
      if @team.create_team(params[:department_id], params[:team][:employee_teams_attributes])
        format.html do
          flash[:success] = t('.success_notice')
          redirect_to department_teams_path(@department)
        end
      else
        format.html { render :new }
      end
    end
  end

  # patch /departments/:department_id/teams/:id
  def update
    respond_to do |format|
      if params[:team].present? &&
          @team.update_team(params[:team][:employee_teams_attributes], team_params)
        format.html do
          flash[:success] = t('.success_notice')
          redirect_to department_teams_path(@department)
        end
      else
        format.html { render :new }
      end
    end
  end

  # delete /departments/:department_id/teams/:id
  def destroy
    @team.destroy
    respond_to do |format|
      if @team.destroyed?
        format.html do
          flash[:success] = t('.success_notice')
          redirect_to department_teams_path(@department)
        end
      else
        format.html do
          flash[:danger] = t('.error_notice')
          redirect_to department_teams_path(@department)
        end
      end
    end
  end

  # get /teamslist
  def teams_list
    respond_to do |format|
      format.json { render json: current_employee.company.teams.where('name like ?', "%#{params[:q]}%") }
    end
  end

  # get '/teams/team_members'
  def team_members
    @team_members = Employee.where(id: params[:employee_ids])
    @count = params['count']
    respond_to do |format|
      format.js
    end
  end

  private
  def team_params
    params.require(:team).permit(:name, :description, :team_pic, employee_teams_attributes: [:employee_id, :employee_type, :id, :_destroy])
  end
end
