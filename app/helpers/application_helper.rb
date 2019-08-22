require 'attendance'

module ApplicationHelper
  def broadcast(channel, &block)
    message = { channel: channel, data: capture(&block) }
    uri = URI.parse('http://localhost:9292/faye')
    Net::HTTP.post_form(uri, message: message.to_json)
  end

  def check_today_timings?
    setting = current_employee.company.setting
    today_start_time = setting.timings[Time.now.strftime('%A').downcase + '_start_time']
    today_end_time = setting.timings[Time.now.strftime('%A').downcase + '_end_time']
    if (setting.working_days[Time.now.strftime('%A').downcase] && (get_time_in_seconds(Time.now) >= get_time_in_seconds(today_start_time.to_time)) && (get_time_in_seconds(Time.now) <= get_time_in_seconds(today_end_time.to_time)))
      return true
    end
    false
  end

  def get_time_in_seconds(time)
    hours_in_seconds = time.strftime('%H').to_i * 3600
    minutes_in_seconds = time.strftime('%H').to_i * 60
    hours_in_seconds + minutes_in_seconds
  end

  def present_marked?
    @attendance = current_employee.todays_attendance_of_employee
    return false if @attendance.nil?
    
    @attendance.attendance_present?
  end

  def not_checked_out?
    current_employee.todays_attendance_of_employee.logout_time.blank?
  end

  def checked_out?
    current_employee.todays_attendance_of_employee.logout_time.present?
  end

  def admin?
    current_employee.role.eql? Employee::ADMIN_ROLE
  end

  def generate_sidebar_foot_options
    data = []
    if admin?
      events = {
        name: 'Events',
        link: home_events_path,
        icon: 'fas fa-calendar',
        id: 'events_option'
      }
      data.push(events)
    end
    chat = {
      name: 'Messenger',
      link: messages_index_path,
      icon: 'fas fa-comment',
      id: 'chat_option'
    }
    calendar = {
      name: 'Calendar',
      link: events_path,
      icon: 'far fa-calendar-minus'
    }
    settings = {
      name: 'Settings',
      link: settings_path,
      icon: 'fas fa-cog',
      id: 'settings_option'
    }
    data.push(chat).push(calendar).push(settings)
  end

  def generate_sidebar_options
    data = []
    dashboard = {
      name: 'Dashboard',
      link: menus_index_path,
      icon: 'fas fa-chart-line',
      id: 'dashboard_option'
    }
    data.push(dashboard)

    if admin?
      attendance = {
        name: 'Company Attendance',
        link: employee_attendances_path(@current_employee),
        icon: 'fas fa-journal-whills',
        id: 'attendance_option'
      }
      employees = {
        name: 'Employees',
        link: members_path,
        icon: 'fas fa-user',
        id: 'employees_option'
      }
      departments = {
        name: 'Departments',
        link: departments_path,
        icon: 'fas fa-building',
        id: 'departments_option'
      }
      reports = {
        name: 'Reports',
        link: '#',
        icon: 'fas fa-file',
        id: 'reports_option',
        submenu_id: 'reportSubmenu',
        suboptions: [
          {
            name: 'Task Report',
            link: task_report_reports_path,
            icon: 'fa fa-tasks'
          },
          {
            name: 'Velocity Report',
            link: show_employee_velocity_report_path,
            icon: 'fa fa-line-chart'
          },
          {
            name: 'Attendance Report',
            link: attendance_report_path,
            icon: 'fa fa-tasks'
          }
        ]
      }
      data.push(employees).push(departments).push(reports).push(attendance)
    else
      departments = {
        name: 'Departments',
        link: departments_path,
        icon: 'fas fa-building',
        id: 'departments_option'
      }
      employee_tasks = {
        name: 'My Tasks',
        link: employee_tasks_list_path(@current_employee),
        icon: 'fas fa-tasks',
        id: 'employee_tasks_option'
      }
      reports = {
        name: 'Velocity Report',
        link: show_employee_velocity_report_path,
        icon: 'fas fa-file',
        id: 'employee_reports_option'
      }
      employee_attendance = {
        name: 'My Attendance',
        link: employee_attendances_path(current_employee),
        icon: 'fas fa-journal-whills',
        id: 'my_attendance_option'
      }
      data.push(employee_tasks).push(departments).push(reports).push(employee_attendance)
    end
  end
end
