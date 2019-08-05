require 'attendance'

module ApplicationHelper
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
    @velocity_report = {
      name: 'Velocity Report',
      link: show_employee_velocity_report_path,
      icon: 'fas fa-file'
    }
    
    @data.push(@dashboard).push(@velocity_report)

    if admin?
      @teams = {
        name: 'Teams',
        link: teams_path,
        icon: 'fas fa-user-friends'
      }
      @attendance_report = {
        name: 'Attendance Report',
        link: employees_attendance_report_path,
        icon: 'fas fa-chart-line'
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
      @data.push(@employees).push(@attendance_report).push(@departments).push(@teams)
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
