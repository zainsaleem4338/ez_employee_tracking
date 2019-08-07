require 'date'
class TaskObserver < ActiveRecord::Observer
  TASK_DELAY_STATE = { coming_time: 'Coming time', remaining_time: 'Remaining time', delay_time: 'Delay_Time' }.freeze
  TASK_STATUS = 'Completed'.freeze
  def after_create(task)
    Task.delay.add_email_deliver(task.id)
  end

  def before_update(task)
    previous_task = Task.find(task.id)
    @assignable_id = previous_task.assignable_id
    @assignable_type = previous_task.assignable_type
    @task_status = previous_task.status
  end

  def after_update(task)
    Task.delay.update_email_deliver(task.id, @assignable_id, @assignable_type, @task_status)
  end

  def self.task_deadlines_alert
    @task_alert = current_employee.company.setting.task_alert
    employee_tasks = Task.all
    employee_tasks.each do |task|
      employees = task.get_employees(task.assignable_type, task.assignable_id)
      if task.expected_end_date.to_date == DateTime.now.to_date && task.status != TASK_STATUS
        employees.each do |employee|
          TaskMailer.task_deadline_notify(employee, task, TASK_DELAY_STATE[:coming_time]).deliver
        end
      end
      if task.expected_end_date.to_date == DateTime.now.to_date + @task_alert && task.status != TASK_STATUS
        employees.each do |employee|
          TaskMailer.task_deadline_notify(employee, task, TASK_DELAY_STATE[:remaining_time]).deliver
        end
      end
      if task.expected_end_date.to_date < DateTime.now.to_date && task.status != TASK_STATUS
        employees.each do |employee|
          TaskMailer.task_deadline_notify(employee, task, TASK_DELAY_STATE[:delay_time]).deliver
        end
      end
    end
  end
end
