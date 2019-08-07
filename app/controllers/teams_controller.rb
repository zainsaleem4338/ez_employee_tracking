class TeamsController < ApplicationController
  load_and_authorize_resource :department, except: :teams_list
  load_and_authorize_resource through: :department, except: :teams_list
  load_and_authorize_resource :team, through_association: :company, only: :teams_list

  def create
    respond_to do |format|
      if @team.create_team(params[:team][:team_lead_id], params[:employee_tokens], params[:department_id])
        format.html { redirect_to department_teams_path(@department), notice: t('.success_notice') }
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
        format.html { redirect_to department_teams_path(@department), notice: t('.success_notice') }
        format.json { render :show, status: :created, location: @team }
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
        format.html { redirect_to department_teams_path(@department), notice: t('.success_notice') }
        format.json { head :no_content }
      else
        format.html { redirect_to department_teams_path(@department), notice: t('.error_notice') }
      end
    end
  end

  def teams_list
    respond_to do |format|
      format.json { render json: current_employee.company.teams.where('name like ?', "%#{params[:q]}%") }
    end
  end

  private
  def team_params
    params.require(:team).permit(:name, :description, :team_pic)
  end
end
