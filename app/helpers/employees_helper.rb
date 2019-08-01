module EmployeesHelper
  def not_team_task?(task)
    !task.assignable_type.eql? 'Team'
  end

  def team_task?(task)
    task.assignable_type.eql? 'Team'
  end

  def no_current_task?(task)
    return true if task.eql? -1 else return false
  end
end
