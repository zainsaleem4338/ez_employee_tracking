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

  def not_logged_out?
    @attendance = current_employee.todays_attendance_of_employee
    @attendance.logout_time.blank?
  end

  def logged_out?
    @attendance = current_employee.todays_attendance_of_employee
    @attendance.logout_time.present?
  end

  def admin?
    current_employee.role.eql? Employee::ADMIN_ROLE
  end

  def generate_sidebar_foot_options
    @data = []
    if admin?
      @events = {
        name: 'Events',
        link: home_events_path,
        icon: 'fas fa-calendar',
        id: 'events_option'
      }
      @data.push(@events)
    end
    @chat = {
      name: 'Messenger',
      link: messages_index_path,
      icon: 'fas fa-comment',
      id: 'chat_option'
    }
    @calendar = {
      name: 'Calendar',
      link: index_events_path,
      icon: 'far fa-calendar-minus',
      id: 'calendar_option'
    }
    @settings = {
      name: 'Settings',
      link: settings_path,
      icon: 'fas fa-cog',
      id: 'settings_option'
    }
    @data.push(@chat).push(@calendar).push(@settings)
  end

  def generate_sidebar_options
    @data = []
    @dashboard = {
      name: 'Dashboard',
      link: menus_index_path,
      icon: 'fas fa-chart-line',
      id: 'dashboard_option'
    }
    @employee_attendance = {
      name: 'My attendance',
      link: attendance_path(current_employee),
      icon: 'fas fa-journal-whills',
      id: 'my_attendance_option'
    }

    @data.push(@dashboard).push(@employee_attendance)

    if admin?
      @attendance = {
        name: 'Company Attendance',
        link: attendances_path,
        icon: 'fas fa-journal-whills',
        id: 'attendance_option'
      }
      @employees = {
        name: 'Employees',
        link: '#',
        icon: 'fas fa-user',
        id: 'employees_option',
        submenu_id: 'empSubmenu',
        suboptions: [
          {
            name: 'Add Employee',
            link: new_employee_path,
            icon: 'fas fa-plus'
          },
          {
            name: 'View Employees',
            link: employees_path,
            icon: 'fas fa-eye'
          }
        ]
      }

      @departments = {
        name: 'Departments',
        link: '#',
        icon: 'fas fa-building',
        id: 'departments_option',
        submenu_id: 'deptSubmenu',
        suboptions: [
          {
            name: 'Add Department',
            link: new_department_path,
            icon: 'fas fa-plus'
          },
          {
            name: 'View Departments',
            link: departments_path,
            icon: 'fas fa-eye'
          }
        ]
      }
      @reports = {
        name: 'Reports',
        link: reports_path,
        icon: 'fas fa-file',
        id: 'reports_option'
      }
      @add_events = {
        name: 'Add Event',
        link: new_events_path,
        icon: 'fas fa-calendar-week',
        id: 'add_events_option'
      }
      @edit_settings = {
        name: 'Edit Settings',
        link: edit_settings_path,
        icon: 'fas fa-cogs',
        id: 'edit_settings_option'
      }
      @data.push(@employees).push(@departments).push(@reports).push(@attendance).push(@add_events).push(@edit_settings)
    else
      @departments = {
        name: 'Departments',
        link: departments_path,
        icon: 'fas fa-building',
        id: 'departments_option'
      }
      @employee_tasks = {
        name: 'My Tasks',
        link: employee_tasks_list_path(current_employee),
        icon: 'fas fa-tasks',
        id: 'employee_tasks_option'
      }
      @reports = {
        name: 'Velocity Report',
        link: show_employee_velocity_report_path,
        icon: 'fas fa-file',
        id: 'employee_reports_option'
      }
      @data.push(@employee_tasks).push(@departments).push(@reports)
    end
  end
end
