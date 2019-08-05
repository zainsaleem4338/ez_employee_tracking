module EmployeesHelper
  def employee_velocity_nan?(employee_velocity)
    if employee_velocity.to_f.nan? || (employee_velocity == (Float::INFINITY))
      return '-'
    else
      return employee_velocity
    end
  end

  def team_name(team_id)
    current_employee.company.teams.find(team_id).name
  end
end
