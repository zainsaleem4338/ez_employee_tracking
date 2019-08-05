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
    if (get_time_in_seconds(Time.now) > get_time_in_seconds(today_start_time.to_time) && get_time_in_seconds(Time.now) < get_time_in_seconds(today_end_time.to_time))
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
    @attendance.present?
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
      link: '#',
      icon: 'fas fa-calendar'
    }
    @chat = {
      name: 'Chat',
      link: '#',
      icon: 'fas fa-comment'
    }
    @about = {
      name: 'About',
      link: menus_index_path,
      icon: 'fas fa-briefcase'
    }
    @contact = {
      name: 'Contact',
      link: '#',
      icon: 'fas fa-phone'
    }
    @data.push(@events).push(@chat).push(@about).push(@contact)
  end

  def generate_sidebar_options
    @data = []
    @dashboard = {
      name: 'Dashboard',
      link: show_employee_path(current_employee),
      icon: 'fas fa-chart-line'
    }
    @data.push(@dashboard)

    if admin?
      @teams = {
        name: 'Teams',
        link: teams_path,
        icon: 'fas fa-user-friends'
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

      @projects = {
        name: 'Projects',
        link: '#',
        icon: 'fas fa-tasks',
        submenu_id: 'projectSubmenu',
        suboptions: [
          {
            name: 'Add Project',
            link: new_project_path,
            icon: 'fas fa-plus'
          },
          {
            name: 'View Projects',
            link: projects_path,
            icon: 'fas fa-eye'
          }
        ]
      }
      @data.push(@employees).push(@departments).push(@teams).push(@projects)
    else
      @data
    end
  end
end
