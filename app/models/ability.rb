class Ability
  include CanCan::Ability

  def initialize(user)
    # binding.pry

    if user.role == Employee::ADMIN_ROLE
      can :manage, Department

      can [:read, :employees_lists], Employee, active: true
      can [:new, :create], Employee, {company_id: user.company_id}
      can :destroy, Employee

      can :manage, Project, {company_id: user.company_id}
    
    elsif user.role == Employee::TEAM_LEAD_ROLE

      # can :index, Employee do |employee|
      #   employee.employee_teams.each do |team|
      #     user.employee_teams.pluck(:team_id).include?team.team_id
      #   end

      can :read, Employee, Employee.team_employees(user) do |employee|
        employee
      end
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
