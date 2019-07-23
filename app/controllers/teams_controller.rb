class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  def index
    @teams = current_employee.company.teams.all
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
      if @team.create_team(params[:team][:team_lead_id], params[:team][:employee_tokens])
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if params[:team][[:team_lead_id]].present? && params[:team][:employee_tokens].present? &&
        current_employee.company.teams.update_team(params[:team][:team_lead_id], params[:team][:employee_tokens])
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @team.destroyed?
        format.html { redirect_to @team, notice: 'Team was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { render :index, notice: 'Team did not destroyed' }
      end
    end
  end

  private
    def set_team
      @team = current_employee.company.teams.find(params[:id])
    end
    def team_params
      params.require(:team).permit(:name, :description, :department_id)
    end
end
