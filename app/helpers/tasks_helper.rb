module TasksHelper
  def set_assignable_hash(task, assignable_type)
    return nil if task.assignable_type.nil?
    return [task.assignable].to_json.html_safe if task.assignable_type == assignable_type
  end

  def get_assignable_name(task)
    return "unassigned" if task.assignable.nil?
    task.assignable.name.capitalize
  end

  def task_logtime(task)
    task.task_time_logs.inject(0) { |sum, task_log| sum + task_log.hours.to_i }
  end
end
