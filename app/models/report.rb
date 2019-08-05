class Report < ActiveRecord::Base

  def self.attendance_data(current_employee)
    end_date = "31-12-#{Date.today.year}".to_date
    week_days = [1, 2, 3, 4, 5]
    attendances_array = []
    current_employee.company.employees.each do |employee|
      @attendances = employee.attendances.where('status = ?', Attendance::STATUS[:PRESENT]).order(login_time: :asc).select { |attendance| attendance.login_time.year == Date.today.year && attendance.logout_time != nil }
      expected_working_days = (@attendances.first.login_time.to_date..@attendances.last.login_time.to_date).to_a.select { |k| week_days.include?(k.wday) }.count
      leaves = (end_date.month - @attendances.first.login_time.month + 1) * 2
      actual_working_days = @attendances.count
      half_days = @attendances.select { |attendance| ((attendance.logout_time - attendance.login_time) / 3600) <= 6 }.count
      full_days = actual_working_days - half_days
      absents = expected_working_days - actual_working_days
      attendances_array << {
        employee: employee,
        presents: full_days,
        half_days: half_days,
        absents: absents,
        leaves_remaining: leaves - absents - (half_days / 2).floor
      }
    end
    attendances_array
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

  def self.upload_worksheet(data, type, session)
    spreadsheet = session.create_spreadsheet(title = "#{DateTime.now}_#{type}")
    sheet = spreadsheet.worksheets[0]
    folder = session.root_collection.subcollection_by_title(type)
    if folder.nil?
      folder = session.root_collection.create_subcollection(type)
    end
    sheet[1,1] = "Name"
    sheet[1,2] = "Presents"
    sheet[1,3] = "Half Days"
    sheet[1,4] = "Absents"
    sheet[1,5] = "Leaves Remaining"
    data.each.with_index(1) do |att_data, i|
      sheet[i+1,1] = att_data[:employee][:name].downcase.capitalize
      sheet[i+1,2] = att_data[:presents]
      sheet[i+1,3] = att_data[:half_days]
      sheet[i+1,4] = att_data[:absents]
      sheet[i+1,5] = att_data[:leaves_remaining]
    end
    sheet.save
    folder.add(spreadsheet)
  end

end
