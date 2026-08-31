class TeamsController < ApplicationController
  load_and_authorize_resource :department, except: [:teams_list, :team_members]
  load_and_authorize_resource through: :department, except: [:teams_list, :team_members]
  load_and_authorize_resource :team, only: [:teams_list, :team_members]

  # POST /departments/:department_id/teams
  def create
    is_create = @team.save
    respond_to do |format|
      if is_create
        format.html do
          flash[:success] = t('.success_notice')
          redirect_to department_teams_path(@department)
        end
      else
        format.html { render :new }
      end
    end
  end

  # PATCH /departments/:department_id/teams/:id
  def update
    is_updated = @team.update(team_params)
    respond_to do |format|
      if is_updated
        format.html do
          flash[:success] = t('.success_notice')
          redirect_to department_teams_path(@department)
        end
      else
        format.html { render :new }
      end
    end
  end

  # DELETE /departments/:department_id/teams/:id
  def destroy
    @team.destroy
    is_destroyed = @team.destroyed?
    respond_to do |format|
      if is_destroyed
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

  # GET /teamslist
  def teams_list
    respond_to do |format|
      format.json { render json: current_employee.company.teams.where('name like ?', "%#{params[:q]}%") }
    end
  end

  # GET '/teams/team_members'
  def team_members
    @team_members = current_employee.company.employees.where(id: params[:employee_ids])
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
