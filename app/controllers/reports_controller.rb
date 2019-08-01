require 'date'
class ReportsController < ApplicationController
  protect_from_forgery except: :load_task_data_in_report
  def task_report
    @tasks = current_employee.company.tasks.paginate(page: params[:page], per_page: 10)
  end

  def load_task_data_in_report
    task_query_hash = {}
    unless params['project'].empty?
      project = Project.find_by(name: params['project'])
      task_query_hash.merge!(project_id: project.id)
    end
    unless params['status'].empty?
      task_query_hash.merge!(status: params['status'])
    end
    if !params['created_start'].empty? || !params['created_end'].empty?
      if params['created_start'].empty?
        task_query_hash.merge!(start_date: Time.zone.parse(params['created_end']))
      elsif params['created_end'].empty?
        task_query_hash.merge!(start_date: Time.zone.parse(params['created_start']))
      else
        task_query_hash.merge!(start_date: Time.zone.parse(params['created_start'])..Time.zone.parse(params['created_end']))
      end
    end
    if !params['deadline_start'].empty? || !params['deadline_end'].empty?
      if params['deadline_start'].empty?
        task_query_hash.merge!(expected_end_date: Time.zone.parse(params['deadline_end']))
      elsif params['deadline_end'].empty?
        task_query_hash.merge!(expected_end_date: Time.zone.parse(params['deadline_start']))
      else
        task_query_hash.merge!(expected_end_date: Time.zone.parse(params['deadline_start'])..Time.zone.parse(params['deadline_end']))
      end
    end
    @tasks = current_employee.company.tasks.where(task_query_hash).paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.js
    end
  end

  def task_pdf_report
    @tasks = current_employee.company.tasks
    @pagination_disallow = 0
    respond_to do |format|
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
