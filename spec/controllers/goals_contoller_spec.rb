require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
  let(:goal_params) do
    {
        project_id: "2",
        goal_text: "goal text 2",
        expected_date: Date.new(2020,1,2),
        completed_date: Date.new(2020,2,2)
    }
  end
  let(:updated_goal_params) do
    {
        project_id: "2",
        goal_text: "updated goal",
        expected_date: Date.new(2020,1,2),
        completed_date: Date.new(2020,2,2)
    }
  end
  let!(:first_goal) do
    Goal.create!(
        project_id: "1",
        goal_text: "goal text 1",
        expected_date: Date.current,
        completed_date: Date.current
    )
  end
  let(:dirty_goal_params) do
    {
        project_id: "2",
        goal_text: "goal text",
        expected_date: Date.new(2020,1,2),
        completed_date: Date.new(2020,2,2),
        ruby: "Ickus"
    }
  end

  let(:valid_session) { {} }

  it "return s a success response" do
    get :index, params: goal_params, session: valid_session
    expect(response).to be_successful
  end

  it "returns a sucess response" do
    get :show, params: { id: first_goal.id }, session: valid_session
    expect(response).to be_successful
  end

  context "post requests" do
    it "creates a new Goal" do
      expect {
        post :create, params: { goal: goal_params }, session: valid_session
      }.to change(Goal, :count).by(1)
    end


    it "returns the created goal with the right fields" do
      post :create, params: { goal: goal_params }, session: valid_session
      expect(response.body).to eq(Goal.last.to_json)
    end

    it "return ignores superfluous fields" do
      expect_any_instance_of(
          GoalsController
      ).to receive(:goal_params).and_return(goal_params)
      post :create, params: { goal: dirty_goal_params }, session: valid_session
    end
  end

  context "put/patch requests" do
    it "updates the first goal with put" do
      put :update, params: { id: first_goal.id, goal: updated_goal_params }, session: valid_session
      expect(
          JSON.parse(response.body)["project_id"]
      ).to eq(updated_goal_params[:project_id])
    end

    it "updates the first goal with patch" do
      patch :update, params: { id: first_goal.id, goal: updated_goal_params }, session: valid_session
      expect(
          JSON.parse(response.body)["project_id"]
      ).to eq(updated_goal_params[:project_id])
    end

    it "returns ignores superfluous fields" do
      expect_any_instance_of(
          GoalsController
      ).to receive(:goal_params).and_return(goal_params)
      put :update, params: { id: first_goal.id, goal:updated_goal_params }, session: valid_session
    end
  end

  context "delete requests" do
    it "destroys the first goal with delete" do
      expect {
        delete :destroy, params: { id: first_goal.id }, session: valid_session
      }.to change(Goal, :count).by(-1)
    end

    it "return the destroyed goal" do
      delete :destroy, params: { id: first_goal.id }, session: valid_session
      expect(
        response.body
      ).to eq(first_goal.to_json)
    end
  end
end