class TeamsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy, :create, :new]
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  def index
    @teams = current_employee.company.departments.find(params[:department_id]).teams
  end

  def show
  end

  def new
    @team = Team.new
  end

  def edit
  end

  def create
    @team = current_employee.company.teams.new(team_params)
    respond_to do |format|
      if @team.create_team(params[:team][:team_lead_id], params[:employee_tokens], params[:department_id])
        format.html { redirect_to department_teams_path(@department), notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if params[:team].present? &&
        @team.update_team(params[:team][:team_lead_id], params[:employee_tokens], team_params)
        format.html { redirect_to department_teams_path(@department), notice: 'Team was successfully updated.' }
        format.json { render :show, status: :created, location: @team}
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @team.destroy
    respond_to do |format|
      if @team.destroyed?
        format.html { redirect_to department_teams_path(@department), notice: 'Team was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to department_teams_path(@department), notice: 'Unable to delete team' }
      end
    end
  end

  def teams_list
    respond_to do |format|
      format.json { render json: Team.where('name like ?',"%#{params[:q]}%" ) }
    end
  end
  
  private
    def set_department
      @department = Department.find(params[:department_id])
    end
    def set_team
      @team = current_employee.company.departments.find(@department.id).teams.find(params[:id])
    end
    def team_params
      params.require(:team).permit(:name, :description, :team_pic)
    end
end
