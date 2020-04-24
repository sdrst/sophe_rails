require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:event_params) do
    {
        title: "event 2",
        venue: "venue 2",
        event_date: Date.new(2020,1,2)
    }
  end
  let(:updated_event_params) do
    {
        title: "event 2",
        venue: "venue 2",
        event_date: Date.new(2020,1,3)
    }
  end
  let!(:first_event) do
    Event.create!(
        title: "event 1",
        venue: "venue 1",
        event_date: Date.current

    )
  end
  let(:dirty_event_params) do
    {
        title: "event 2",
        venue: "venue 2",
        event_date: Date.current,
        ruby: "Ickus"
    }
  end

  let(:valid_session) { {} }

  it "returns a success response" do
    get :index, params: event_params, session: valid_session
    expect(response).to be_successful
  end

  it "returns a success response" do
    get :show, params: { id: first_event.id }, session: valid_session
    expect(response).to be_successful
  end

  context "post requests" do
    it "creates a new Event" do
      expect {
        post :create, params: { event: event_params }, session: valid_session
      }.to change(Event, :count).by(1)
    end

    it "returns the created event with the right fields" do
      post :create, params: { event: event_params }, session: valid_session
      expect(response.body).to eq(Event.last.to_json)
    end

    it "returns ignores superfluous fields" do
      expect_any_instance_of(
          EventsController
      ).to receive(:event_params).and_return(event_params)
      post :create, params: { event: dirty_event_params }, session: valid_session
    end
  end

  context "put/patch requests" do
    it "updates the first event with put" do
      put :update, params: { id: first_event.id, event: updated_event_params }, session: valid_session
      expect(
        JSON.parse(response.body)["title"]
      ).to eq(updated_event_params[:title])
    end

    it "updates the first event with patch" do
      patch :update, params: { id: first_event.id, event: updated_event_params }, session: valid_session
      expect(
        JSON.parse(response.body)["title"]
      ).to eq(updated_event_params[:title])
    end

    it "returns ignores superfluous fields" do
      expect_any_instance_of(
          EventsController
      ).to receive(:event_params).and_return(event_params)
      put :update, params: { id: first_event.id, event: updated_event_params }, session: valid_session
    end
  end

  context "delete requests" do
    it "destroys the first event with delete" do
      expect {
        delete :destroy, params: { id: first_event.id }, session: valid_session
      }.to change(Event, :count).by(-1)
    end

    it "returns the destroyed event" do
      delete :destroy, params: { id: first_event.id }, session: valid_session
      expect(
        response.body
      ).to eq(first_event.to_json)
    end
  end
end
