require "rails_helper"

RSpec.describe Report, type: :model do
  let(:links) { "test.com" }
  let(:project_id) { "1" }
  let(:text) { "text" }
  let(:report) do
    Report.new(
        links: links,
        project_id: project_id,
        text: text
    )
  end

  it "sets the fields properly" do
    expect(report.links).to eq(links)
    expect(report.project_id).to eq(project_id)
    expect(report.text).to eq(text)
  end
end