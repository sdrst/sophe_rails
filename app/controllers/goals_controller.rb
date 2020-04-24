class GoalsController < ApplicationController
  protect_from_forgery

  def index
    render json: Goal.all
  end

  def show
    render json: goal
  end

  def create
    render json: Goal.create!(goal_params)
  end

  def update
    goal.update!(goal_params)
    render json: goal
  end

  def destroy
    destroyed_goal = goal.destroy!
    render json: destroyed_goal
  end

  private

  def goal
    Goal.find(params[:id])
  end

  def goal_params
    params.require(:goal).permit(:project_id, :goal_text, :expected_date, :completed_date)
  end
end