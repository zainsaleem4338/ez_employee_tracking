module MenusHelper
  def get_on_going_tasks
    if current_employee.role == Employee::ADMIN_ROLE
      current_employee.company.tasks.where('status in (?)', [Task::NEW_STATUS, Task::IN_PROGRESS, Task::ASSIGNED_STATUS, Task::READY_TO_REVIEW])
    elsif current_employee.role == Employee::EMPLOYEE_ROLE
      current_employee.company.tasks.where('assignable_id = ? and assignable_type = ?', current_employee.id, Employee::EMPLOYEE_ROLE)
    end
  end

  def get_overdue_tasks_count
    if current_employee.role == Employee::ADMIN_ROLE
      current_employee.company.tasks.where('expected_end_date < (?)', Date.today).count
    elsif current_employee.role == Employee::EMPLOYEE_ROLE
      current_employee.company.tasks.where('assignable_id = ? and assignable_type = ? and expected_end_date < (?)',current_employee.id, Employee::EMPLOYEE_ROLE, Date.today).count
    end
  end

  def get_overdue_tasks
    if current_employee.role == Employee::ADMIN_ROLE
      current_employee.company.tasks.where('expected_end_date < (?)', Date.today)
    elsif current_employee.role == Employee::EMPLOYEE_ROLE
      current_employee.company.tasks.where('assignable_id = ? and assignable_type = ? and expected_end_date < (?)',current_employee.id, Employee::EMPLOYEE_ROLE, Date.today)
    end
  end

  def get_tasks_reaching_deadline
    if current_employee.role == Employee::ADMIN_ROLE
      current_employee.company.tasks.where('expected_end_date < (?)', Date.today+(3.day))
    elsif current_employee.role == Employee::EMPLOYEE_ROLE
      current_employee.company.tasks.where('assignable_id = ? and assignable_type = ? and expected_end_date < (?)',current_employee.id, Employee::EMPLOYEE_ROLE, Date.today+3.day)
    end
  end

  def get_task_badge_class(task_status)
    if task_status == Task::IN_PROGRESS
      return 'success'
    elsif task_status == Task::ASSIGNED_STATUS
      return 'info'
    elsif task_status == Task::NEW_STATUS
      return 'success'
    elsif task_status == Task::READY_TO_REVIEW
      return 'warning'
    elsif task_status == Task::REVIEW_COMPLETED
      return 'success'
    end
        
  end
end