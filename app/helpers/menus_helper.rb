module MenusHelper
  def get_on_going_tasks
    current_employee.company.tasks.where('status in (?)', [Task::NEW_STATUS, Task::IN_PROGRESS, Task::ASSIGNED_STATUS, Task::READY_TO_REVIEW])
  end

  def get_overdue_tasks_count
    current_employee.company.tasks.where('expected_end_date < (?)', Date.today).count
  end

  def get_overdue_tasks
    current_employee.company.tasks.where('expected_end_date < (?)', Date.today)
  end

  def get_tasks_reaching_deadline
    current_employee.company.tasks.where('expected_end_date < (?)', Date.today+(3.day))
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