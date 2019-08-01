namespace :email_task do
  desc 'This task send task deadline alerts to employees'
  task task_email_send: :environment do
    TaskObserver.task_deadlines_alert
    puts "Email Sent"
  end
end
