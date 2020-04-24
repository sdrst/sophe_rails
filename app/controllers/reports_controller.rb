class ReportsController < ApplicationController
  protect_from_forgery

  def index
    render json: Report.all
  end

  def show
    render json: report
  end

  def create
    render json: Report.create!(report_params)
  end

  def update
    report.update!(report_params)
    render json: report
  end

  def destroy
    destroyed_report = report.destroy!
    render json: destroyed_report
  end

  private

  def report
    Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:links, :project_id, :text)
  end
end