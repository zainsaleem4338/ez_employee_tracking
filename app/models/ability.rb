class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == Employee::ADMIN_ROLE
      can :manage, Department, company_id: user.company_id
      can [:read, :employees_lists, :attendance_report, :attendance_report_pdf, :pdf_velocity_report], Employee, active: true
      can [:new, :create], Employee, company_id: user.company_id
      can :destroy, Employee
      can :manage, Project, company_id: user.company_id
      can :manage, Task, company_id: user.company_id
      can :manage, Event, company_id: user.company_id
      can :manage, Setting, company_id: user.company_id
      can :manage, Message, company_id: user.company_id

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

      can :read, Company
      can :read, Event, company_id: user.company_id
      can :read, Setting, company_id: user.company_id
    end
  end
end
