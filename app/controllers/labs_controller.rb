class LabsController < ApplicationController
  protect_from_forgery

  def index
    render json: Lab.all
  end

  def show
    render json: lab
  end

  def create
    render json: Lab.create!(lab_params)
  end

  def update
    lab.update!(lab_params)
    render json: lab
  end

  def destroy
    destroyed_lab = lab.destroy!
    render json: destroyed_lab
  end

  private

  def lab
    Lab.find(params[:id])
  end

  def lab_params
    params.require(:lab).permit(:name)
  end
end
