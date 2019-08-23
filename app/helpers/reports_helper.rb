module ReportsHelper
  def employee_velocity(employee_velocity)
    if employee_velocity.to_f.nan? || (employee_velocity == (Float::INFINITY))
      return '-'
    else
      return employee_velocity.round(2)
    end
  end

  def team_name(team_id)
    current_employee.company.teams.find(team_id).name.downcase.titleize
  end

  def team_tasks_count(team_id)
    current_employee.company.teams.find(team_id).tasks.count
  end

  def team_employees_count(team_id)
    current_employee.company.teams.find(team_id).employees.count
  end

  def team_department_name(team_id)
    current_employee.company.teams.find(team_id).department.name.downcase.titleize
  end

end
