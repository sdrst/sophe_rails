require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let(:report_params) do
    {
        links: "test.com",
        project_id: "1",
        text: "text"
    }
  end
  let(:updated_report_params) do
    {
        links: "updated_test.com",
        project_id: "1",
        text: "text"
    }
  end
  let!(:first_report) do
    Report.create!(
        links: "test.com",
        project_id: "1",
        text: "text"
    )
  end
  let(:dirty_report_params) do
    {
        links: "test.com",
        project_id: "1",
        text: "text",
        ruby: "Ickus"
    }
  end

  let(:valid_session) { {} }

  it "returns a success response" do
    get :index, params: report_params, session: valid_session
    expect(response).to be_successful
  end

  context "post requests" do
    it "creates a new Report" do
      expect {
        post :create, params: { report: report_params }, session: valid_session
      }.to change(Report, :count).by(1)
    end

    it "returns the created report with the right fields" do
      post :create, params: { report: report_params }, session: valid_session
      expect(response.body).to eq(Report.last.to_json)
    end

    it "return ignores superfluous fields" do
      expect_any_instance_of(
          ReportsController
      ).to receive(:report_params).and_return(report_params)
      post :create, params: { event: dirty_report_params }, session: valid_session
    end
  end

  context "put/patch requests" do
    it "updates the first report with put" do
      put :update, params: { id: first_report.id, report: updated_report_params }, session: valid_session
      expect(
          JSON.parse(response.body)["links"]
      ).to eq(updated_report_params[:links])
    end

    it "updates the first report with patch" do
      patch :update, params: { id: first_report.id, report: updated_report_params}, session: valid_session
      expect(
          JSON.parse(response.body)["links"]
      ).to eq(updated_report_params[:links])
    end
  end

  context "delete requests" do
    it "destroys the first report with delete" do
      expect {
        delete :destroy, params: { id: first_report.id }, session: valid_session
      }.to change(Report, :count).by(-1)
    end

    it "return the destroyed report" do
      delete :destroy, params: { id: first_report.id }, session: valid_session
      expect(
        response.body
      ).to eq(first_report.to_json)
    end
  end
end