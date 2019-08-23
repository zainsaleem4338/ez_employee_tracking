class MembersController < ApplicationController
  load_and_authorize_resource :member, through_association: :company, class: 'Employee'
  load_and_authorize_resource :team, through_association: :company

  def index
    @members = @members.paginate(page: params[:page], per_page: 5)
  end
  # get /employee_lists
  def employees_lists
    if params[:department].blank?
      @employees = current_employee.company.employees.active_members.order(:name)
    else
      @employees = current_employee.company.departments.find_by(id: params[:department].to_i).employees.active_members.order(:name)
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
    @employee = current_employee.company.employees.find_by(sequence_num: params[:sequence_num])
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
