module EmployeesHelper
  def not_team_task?(task)
    !task.assignable_type.eql? 'Team'
  end

  def team_task?(task)
    return false if task.eql? -1
    task.assignable_type.eql? 'Team'
  end

  def no_current_task?(task)
    task.eql? -1
  end

  def employee_velocity_nan?(employee_velocity)
    employee_velocity.to_f.nan? || (employee_velocity == (Float::INFINITY))
  end
end
