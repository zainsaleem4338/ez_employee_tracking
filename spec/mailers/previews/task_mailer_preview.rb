# Preview all emails at http://localhost:3000/rails/mailers/task_mailer
class TaskMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/task_mailer/assign_task_notify
  def assign_task_notify
    TaskMailer.assign_task_notify
  end

end
