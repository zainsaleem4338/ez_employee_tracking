require 'date'
class ReportsController < ApplicationController
  protect_from_forgery except: :load_task_data_in_report
  def task_report
    @tasks = current_employee.company.tasks.paginate(page: params[:page], per_page: 10)
  end

  def get_task_query_hash(param_project, status, created_start, created_end, deadline_start, deadline_end)
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

  def load_task_data_in_report
    task_hash = get_task_query_hash(params['project'], params['status'], params['created_start'], params['created_end'], params['deadline_start'], params['deadline_end'])
    @tasks = current_employee.company.tasks.where(task_hash).paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.js
    end
  end

  def task_pdf_csv_report
    task_hash = get_task_query_hash(params['project'], params['status'], params['created_start'], params['created_end'], params['deadline_start'], params['deadline_end'])
    @tasks = current_employee.company.tasks.where(task_hash)
    if params[:pdf]
      @pagination_disallow = 0
      request.format = :pdf
    elsif params[:csv]
      request.format = :csv
    end
    respond_to do |format|
      format.csv do
        send_data Report.to_csv(@tasks), filename: "task-#{Time.zone.now.to_datetime}.csv"
      end
      format.pdf do
        render pdf: 'Tasks',
        template: 'reports/task_pdf_report.html.erb',
        layout: 'pdf.html',
        page_size: 'A4',
        dpi: 55
      end
    end
  end
end
