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
end
