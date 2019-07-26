class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == Employee::ADMIN_ROLE
      can :manage, Department

      can [:read, :employees_lists], Employee, active: true
      can [:new, :create], Employee, company_id: user.company_id
      can :destroy, Employee

      can :manage, Project, company_id: user.company_id
    else
      # can :read, Employee, Employee.team_employees(user) do |employee|
      #   employee
      # end

      can :read, Project, Project.get_projects(user) do |project|
      	project
      end

      can :read, Company
      can :manage, Department
      can :manage, Employee, company_id: user.company_id
      # can :manage, Project, company_id: user.company_id
      can :manage, Task, company_id: user.company_id
      can :update_status, Task, company_id: user.company_id
      # can :cre, Task, company_id: user.company_id
    end
  end
end
