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
    task.assignable.name.capitalize
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
end
