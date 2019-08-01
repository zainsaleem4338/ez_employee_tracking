class TaskMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.task_mailer.assign_task_notify.subject
  #
  def assign_task_notify(employee, task)
    @employee = employee
    @task = task

    mail to: employee.email, subject: 'New Task Assigned'
  end

  def unassign_task_notify(employee, task)
    @employee = employee
    @task = task

    mail to: employee.email, subject: 'Un-Assign Task'
  end

  def change_task_status_notify(employee, task)
    @employee = employee
    @task = task

    mail to: employee.email, subject: 'Task Status Change'
  end

  def task_deadline_notify(employee, task, task_delay_state)
    @employee = employee
    @task = task
    @delay_state = task_delay_state
    mail to: employee.email, subject: 'Task Deadline Alert'
  end
end
