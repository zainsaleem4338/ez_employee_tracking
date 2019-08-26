class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == Employee::ADMIN_ROLE
      can :manage, Department, company_id: user.company_id
      can [:read, :employees_lists, :pdf_velocity_report], Employee, active: true, company_id: user.company_id
      can [:new, :create], Employee, company_id: user.company_id
      can :manage, Attendance, company_id: user.company_id
      can :destroy, Employee, company_id: user.company_id
      can :manage, Project, company_id: user.company_id
      can :manage, Task, company_id: user.company_id
      can :manage, Event, company_id: user.company_id
      can :manage, Setting, company_id: user.company_id
      can :manage, Message, company_id: user.company_id
      can :manage, Team, company_id: user.company_id
      can :manage, Report, company_id: user.company_id
    else
      can [:read, :pdf_velocity_report], Employee, user.company.employees.team_employees(user) do |employee|
        employee.company_id == user.company_id
      end

      can :read, Project, user.company.projects.get_projects(user) do |project|
        user.company.projects.where(id: user.tasks.pluck(:project_id)) && project.company_id == user.company_id
      end
      can [:employee_tasks, :update_task_logtime], Task, user.company.tasks.get_employee_tasks(user) do |employee_task|
        employee_task.company_id == user.company_id
      end

      can [:index, :update_status, :edit_status, :show], Task, user.company.tasks.get_tasks(user) do |task|
        user.tasks.pluck(:id).include?(task.id) && task.company_id == user.company_id
      end

      can :read, Department, user.company.departments.get_departments(user) do |department|
        user.department.id == department.id && department.company_id == user.company_id
      end

      can :read, Team, user.company.teams.show_teams_employee(user) do |team|
        team.company_id == user.company_id
      end

      can :read, Company
      can :read, Event, company_id: user.company_id
      can :read, Setting, company_id: user.company_id
      can :manage, Message, company_id: user.company_id
      can :manage, Attendance, company_id: user.company_id
    end
  end
end
