require 'csv'
class Report
  def self.to_csv(tasks)
    options = {}
    header = ['Project Name', 'Task Name', 'Start Date', 'End Date',
                      'Assigned To', 'Assigned Type', 'Status']
    CSV.generate(options) do |csv|
      csv << header
      tasks.each do |task|
        csv << [task.project.name, task.name, task.start_date.to_date, task.expected_end_date.to_date,
                task.assignable.name, task.assignable_type, task.status]
      end
    end
  end
end
