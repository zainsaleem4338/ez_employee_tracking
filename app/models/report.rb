class Report < ActiveRecord::Base
  def self.compute_one_employee_velocity(employee_id, tasks_list)
    @total_time_on_tasks = time_spent_on_tasks(employee_id, tasks_list).to_i
    @total_task_complexity = compute_total_complexity_of_tasks(tasks_list).to_i
    (@total_task_complexity.to_f / @total_time_on_tasks)
  end

  def self.compute_total_complexity_of_tasks(employee_tasks)
    return 0 if employee_tasks.blank?

    employee_tasks.inject(0) { |sum, task| sum + task.complexity }
  end

  def self.time_spent_on_tasks(employee_id, employee_tasks)
    return 0 if employee_tasks.blank?

    @sum = 0
    employee_tasks.each do |task|
      @task_log = task.task_time_logs.where(employee_id: employee_id)
      unless @task_log.blank?
        @sum += @task_log.inject(0) { |log_sum, task_log| log_sum + task_log.hours.to_i }
      end
    end
    @sum
  end

  def self.compute_employees_velocity(current_employee)
    if current_employee.role == Employee::EMPLOYEE_ROLE
      @employee_teams = current_employee.teams
    elsif current_employee.role == Employee::ADMIN_ROLE
      @employee_teams = current_employee.company.teams
    end

    @employee_tasks_data = {}

    @employee_teams.each do |team|
      @employees_list = team.employees
      @employee_tasks_data[team.id] = {}
      @employees_list.each do |employee|
        @employee_tasks = employee.company.tasks.get_employee_tasks(employee)
        @employee_tasks_data[team.id][employee.id] = {
          employee_id: employee.id,
          employee_name: employee.name,
          total_tasks: @employee_tasks.count,
          total_time: time_spent_on_tasks(employee.id, @employee_tasks),
          total_complexity: compute_total_complexity_of_tasks(@employee_tasks),
          velocity: compute_one_employee_velocity(employee.id, @employee_tasks)
        }
      end
    end
    @employee_tasks_data
  end
end