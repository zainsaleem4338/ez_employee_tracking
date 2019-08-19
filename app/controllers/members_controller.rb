class MembersController < ApplicationController
  load_and_authorize_resource :member, through_association: :company, class: 'Employee', find_by: :sequence_num
  # authorize_resource :member, through: :current_company
  load_and_authorize_resource :team, through_association: :company

  # get /employee_lists
  def employees_lists
    if params['department'].blank?
      @employees = current_employee.company.employees.active_members.order(:name)
    else
      @employees = current_employee.company.departments.find(params['department'].to_i).employees.active_members.order(:name)
    end
    respond_to do |format|
      format.json { render json: @employees.where('role != ? AND name like ?', Employee::ADMIN_ROLE, "%#{params[:q]}%") }
    end
  end

  # post /employees/create
  def create
    @member.password = generate_password
    if @member.save
      flash[:success] = t('.success_notice')
      redirect_to menus_index_path
    else
      render 'new'
    end
  end

  # DELETE /employees/:id
  def destroy
    @member.active = false
    flash[:danger] = t('.inactive_notice')
    if @member.save
      redirect_to members_path
    else
      redirect_to menus_index_path
    end
  end

  # get /employees/:sequence_num/show
  def show
    # binding.pry
    # @employee = Employee.find_by(sequence_num: params[:id])
  end

  # get '/employees/team_member_render_view'
  def team_member_render_view
    @team_members = Employee.where(id: params['employee_ids'])
    @count = params['count']
    respond_to do |format|
      format.js
    end
  end

  private

  def member_params
    params.require(:employee).permit(:name, :email, :password, :role, :company_id, :department_id, :avatar)
  end

  def generate_password
    random_password = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...10).map { random_password[rand(random_password.length)] }.join
  end
end
