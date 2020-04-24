require "rails_helper"

RSpec.describe Goal, type: :model do
  let(:project_id) { "test_id" }
  let(:goal_text)  { "goal text" }
  let(:expected_date) { Date.current }
  let(:completed_date) { Date.current }
  let(:goal) do
    Goal.new(
        project_id: project_id,
        goal_text: goal_text,
        expected_date: expected_date,
        completed_date: completed_date
    )
  end

  it "sets the fields properly" do
    expect(goal.project_id).to eq(project_id)
    expect(goal.goal_text).to eq(goal_text)
    expect(goal.expected_date).to eq(expected_date)
    expect(goal.completed_date).to eq(completed_date)
  end
end
