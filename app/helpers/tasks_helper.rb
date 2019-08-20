module TasksHelper
  def set_assignable_hash(task, assignable_type)
    return nil if task.assignable_type.nil?
    return [task.assignable].to_json.html_safe if task.assignable_type == assignable_type
  end

  def task_time_logs_form(task)
    task.task_time_logs.where(employee_id: current_employee.id).first
  end

  def get_assignable_name(task)
    return Task::UNASSIGNED_STATUS if task.assignable.nil?
    task.assignable.name.titleize
  end

  def get_assignable_type(task)
    return Task::UNASSIGNED_STATUS if task.assignable.nil?
    task.assignable_type.capitalize
  end

  def task_logtime(task)
    task.task_time_logs.inject(0) { |sum, task_log| sum + task_log.hours.to_i }
  end

  def get_reviewer_hash(task)
    return nil if task.reviewer_id.nil?
    return [task.reviewer].to_json.html_safe
  end

  def get_time_logs(task)
    task.task_time_logs
  end

  def log_by_employee(log)
    log.company.employees.find_by(log.employee_id).name
  end

  def task_status_percentage(task)
    if task.status == Task::NEW_STATUS
      return 10
    elsif task.status == Task::ASSIGNED_STATUS
      return 20
    elsif task.status == Task::IN_PROGRESS
      return 60
    elsif task.status == Task::READY_TO_REVIEW
      return 80
    elsif task.status == Task::REVIEW_COMPLETED
      return 100
    end
  end

  def task_time_logs_form(task)
    task.task_time_logs.where(employee_id: current_employee.id).first
  end
end
