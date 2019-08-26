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

  def self.single_team_velocity(current_employee, team_id)
    if current_employee.role == Employee::EMPLOYEE_ROLE
      @employee_teams = current_employee.teams.find(team_id)
    elsif current_employee.role == Employee::ADMIN_ROLE
      @employee_teams = current_employee.company.teams.find(team_id)
    end

    @employee_tasks_data = {}
    team = @employee_teams
    @employees_list = team.employees
    # @employee_tasks_data[team.id] = {}
    @employees_list.each do |employee|
      @employee_tasks = employee.company.tasks.get_employee_tasks(employee)
      @employee_tasks_data[employee.id] = {
        employee_id: employee.id,
        employee_name: employee.name,
        total_tasks: @employee_tasks.count,
        total_time: time_spent_on_tasks(employee.id, @employee_tasks),
        total_complexity: compute_total_complexity_of_tasks(@employee_tasks),
        velocity: compute_one_employee_velocity(employee.id, @employee_tasks)
      }
    end
    @employee_tasks_data
  end

  def self.attendance_data(current_employee, all_employees = true)
    attendances_array = []
    holidays = []
    current_employee.company.setting.holidays.each do |index, date|
      holidays << date["holiday_date_#{index}"]
    end

    if all_employees
      current_employee.company.employees.each do |employee|
        @attendances = employee.attendances.where(status: Attendance::STATUS[:PRESENT]).order(login_time: :asc).select { |attendance| attendance.login_time.year == Date.today.year && attendance.logout_time != nil }
        if !@attendances.empty?
          full_days, half_days, absents, leaves_remaining = attendance_details(@attendances, holidays, current_employee)
          attendances_array << {
            employee: employee,
            presents: full_days,
            half_days: half_days,
            absents: absents,
            leaves_remaining: leaves_remaining
          }
        end
      end
      return attendances_array
    else
      @attendances = current_employee.attendances.where(status: Attendance::STATUS[:PRESENT]).order(login_time: :asc).select { |attendance| attendance.login_time.year == Date.today.year && attendance.logout_time != nil }
      if !@attendances.empty?
        full_days, half_days, absents, leaves_remaining = attendance_details(@attendances, holidays, current_employee)
        return leaves_remaining
      end
      return 0
    end
  end

  def self.attendance_details(attendances, holidays, current_employee)
    end_date = "31-12-#{Date.today.year}".to_date
    week_days = [1, 2, 3, 4, 5]
    first_attendance_date = attendances.first.login_time.to_date
    last_attendance_date = attendances.last.login_time.to_date
    public_holidays = holidays.select {|date| date.to_date > first_attendance_date && date.to_date < last_attendance_date}.count
    expected_working_days = (first_attendance_date..last_attendance_date).to_a.select { |k| week_days.include?(k.wday) }.count - public_holidays
    leaves = (end_date.month - first_attendance_date.month + 1) * (current_employee.company.setting.allocated_leaves / 12 )
    actual_working_days = attendances.count
    half_days = attendances.select { |attendance| ((attendance.logout_time - attendance.login_time) / 3600) <= 6 }.count
    full_days = actual_working_days - half_days
    absents = expected_working_days - actual_working_days
    return full_days, half_days, absents, (leaves - absents - (half_days / 2).floor)
  end

  def self.get_task_query_hash(param_project, status, created_start, created_end, deadline_start, deadline_end)
    task_query_hash = {}
    unless param_project.empty?
      project = Project.find_by(name: param_project)
      unless project.blank?
        task_query_hash[:project_id] = project.id
      else
        task_query_hash[:project_id] = ''
      end
    end
    unless status.empty?
      task_query_hash[:status] = status
    end
    if !created_start.empty? || !created_end.empty?
      if created_start.empty?
        task_query_hash[:start_date] = Time.zone.parse(created_end)
      elsif created_end.empty?
        task_query_hash[:start_date] = Time.zone.parse(created_start)
      else
        task_query_hash[:start_date] = Time.zone.parse(created_start)..Time.zone.parse(created_end)
      end
    end
    if !deadline_start.empty? || !deadline_end.empty?
      if deadline_start.empty?
        task_query_hash[:expected_end_date] = Time.zone.parse(deadline_end)
      elsif deadline_end.empty?
        task_query_hash[:expected_end_date] = Time.zone.parse(deadline_start)
      else
        task_query_hash[:expected_end_date] = Time.zone.parse(deadline_start)..Time.zone.parse(deadline_end)
      end
    end
    task_query_hash
  end

  def self.get_task_query_hash(param_project, status, created_start, created_end, deadline_start, deadline_end)
    task_query_hash = {}
    unless param_project.empty?
      project = Project.find_by(name: param_project)
      unless project.blank?
        task_query_hash[:project_id] = project.id
      else
        task_query_hash[:project_id] = ''
      end
    end
    unless status.empty?
      task_query_hash[:status] = status
    end
    if !created_start.empty? || !created_end.empty?
      if created_start.empty?
        task_query_hash[:start_date] = Time.zone.parse(created_end)
      elsif created_end.empty?
        task_query_hash[:start_date] = Time.zone.parse(created_start)
      else
        task_query_hash[:start_date] = Time.zone.parse(created_start)..Time.zone.parse(created_end)
      end
    end
    if !deadline_start.empty? || !deadline_end.empty?
      if deadline_start.empty?
        task_query_hash[:expected_end_date] = Time.zone.parse(deadline_end)
      elsif deadline_end.empty?
        task_query_hash[:expected_end_date] = Time.zone.parse(deadline_start)
      else
        task_query_hash[:expected_end_date] = Time.zone.parse(deadline_start)..Time.zone.parse(deadline_end)
      end
    end
    task_query_hash
  end
end
