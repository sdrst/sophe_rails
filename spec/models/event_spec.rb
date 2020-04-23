require "rails_helper"

RSpec.describe Event, type: :model do
  let(:title) { "test_title" }
  let(:venue) { "test_venue"}
  let(:event_date) { Date.current}
  let(:event) do
    Event.new(
      title: title,
      venue: venue,
      event_date: event_date
    )
  end

  it "sets the fields properly" do
    expect(event.title).to eq(title)
    expect(event.venue).to eq(venue)
    expect(event.event_date).to eq(event_date)
  end
  
end
