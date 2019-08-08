class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == Employee::ADMIN_ROLE && user.department.nil?
      can :manage, Department, company_id: user.company_id
      can [:read, :employees_lists, :team_member_render_view, :pdf_velocity_report], Employee, active: true, company_id: user.company_id
      can [:new, :create], Employee, company_id: user.company_id
      can :destroy, Employee, company_id: user.company_id
      can :manage, Project, company_id: user.company_id
      can :manage, Task, company_id: user.company_id
      can :manage, Event, company_id: user.company_id
      can :manage, Setting, company_id: user.company_id
      can :manage, Message, company_id: user.company_id
      can :manage, Team, company_id: user.company_id
      can :manage, Report, company_id: user.company_id

    elsif user.role == Employee::ADMIN_ROLE && user.department.present?
      can :manage, Project do |project|
        project.department_id == user.department_id
        project.company_id    == user.company_id
      end

      can :manage, Department do |department|
        department.id            == user.department_id
        department.company_id    == user.company_id
      end

      can :manage, Task do |task|
        task.project.department.id == user.department_id
        task.company_id            == user.company_id
      end


    else
      can [:read, :pdf_velocity_report], Employee, Employee.team_employees(user) do |employee|
        employee
      end
      can :read, Project, Project.get_projects(user) do |project|
        project
      end
      can [:employee_tasks, :update_task_logtime], Task, Task.get_employee_tasks(user) do |employee_task|
        employee_task
      end

      can [:read, :update_status, :edit_status], Task, Task.get_tasks(user) do |task|
        task
      end

      can :read, Department, Department.get_departments(user) do |department|
        department
      end

      can :read, Team, Team.show_teams_employee(user) do |team|
        team
      end

      can :read, Company
      can :read, Event, company_id: user.company_id
      can :read, Setting, company_id: user.company_id
      can :manage, Message, company_id: user.company_id
    end
  end
end
