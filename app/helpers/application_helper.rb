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
    @attendance.logout_empty?
  end

  def admin?
    current_employee.role.eql? Employee::ADMIN_ROLE
  end

  def generate_sidebar_foot_options
    @data = []
    @events = {
      name: 'Events',
      link: home_events_path,
      icon: 'fas fa-calendar'
    }
    @chat = {
      name: 'Messenger',
      link: messages_index_path,
      icon: 'fas fa-comment'
    }
    @calendar = {
      name: 'Calendar',
      link: index_events_path,
      icon: 'far fa-calendar-minus'
    }
    @settings = {
        name: 'Settings',
        link: settings_path,
        icon: 'fas fa-cog'
     }
    @data.push(@events).push(@chat).push(@calendar).push(@settings)
  end

  def generate_sidebar_options
    @data = []
    @dashboard = {
      name: 'Dashboard',
      link: menus_index_path,
      icon: 'fas fa-chart-line'
    }

    @data.push(@dashboard)

    if admin?
      @attendance = {
        name: 'Attendance',
        link: attendances_path,
        icon: 'fas fa-journal-whills'
      }
      @employees = {
        name: 'Employees',
        link: '#',
        icon: 'fas fa-user',
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
        name: 'Department',
        link: '#',
        icon: 'fas fa-building',
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
        icon: 'fas fa-file'
      }
      @add_events = {
        name: 'Add Event',
        link: new_events_path,
        icon: 'fas fa-calendar-week'
      }
      @edit_settings = {
        name: 'Edit Settings',
        link: edit_settings_path,
        icon: 'fas fa-cogs'
      }
      @data.push(@employees).push(@departments).push(@attendance).push(@add_events).push(@edit_settings)
    else
      @employee_tasks = {
        name: 'My Tasks',
        link: employee_tasks_list_path(current_employee),
        icon: 'fas fa-tasks'
      }
      @data.push(@employee_tasks)
    end
  end
end
