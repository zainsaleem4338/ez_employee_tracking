class TeamsController < ApplicationController

    def teams_list

    respond_to do |format|
      # binding.pry
      # format.json { render json: @employees.where('name != ? AND department_id = AND name like ?', 'Admin', dept, "%#{params[:term]}%") }
      format.json { render json: Team.where('name like ?',"%#{params[:q]}%" ) }
    end
  end


end
