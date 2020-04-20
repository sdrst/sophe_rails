require "rails_helper"

RSpec.describe Lab, type: :model do
  let(:lab_name) { "test_lab_1" }
  let(:lab) do
    Lab.new(
      name: lab_name
    )
  end

  it "sets the fields properly" do
    expect(lab.name).to eq(lab_name)
  end
end
