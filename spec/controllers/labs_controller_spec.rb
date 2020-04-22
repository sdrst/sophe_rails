require 'rails_helper'

RSpec.describe LabsController, type: :controller do
  let(:lab_params) do
    {
      name: "lab 2"
    }
  end
  let(:updated_lab_params) do
    {
      name: "updated lab 2"
    }
  end
  let!(:first_lab) do
    Lab.create!(
      name: "lab 1"
    )
  end
  let(:dirty_lab_params) do
    {
      name: "lab 2",
      ruby: "Ickus"
    }
  end

  let(:valid_session) { {} }

  it "returns a success response" do
    get :index, params: lab_params, session: valid_session
    expect(response).to be_successful
  end

  it "returns a success response" do
    get :show, params: { id: first_lab.id }, session: valid_session
    expect(response).to be_successful
  end

  context "post requests" do
    it "creates a new Lab" do
      expect {
        post :create, params: { lab: lab_params }, session: valid_session
      }.to change(Lab, :count).by(1)
    end

    it "returns the created lab with the right fields" do
      post :create, params: { lab: lab_params }, session: valid_session
      expect(response.body).to eq(Lab.last.to_json)
    end

    it "returns ignores superfluous fields" do
      expect_any_instance_of(
        LabsController
      ).to receive(:lab_params).and_return(lab_params)
      post :create, params: { lab: dirty_lab_params }, session: valid_session
    end
  end

  context "put/patch requests" do
    it "updates the first lab with put" do
      put :update, params: { id: first_lab.id, lab: updated_lab_params }, session: valid_session
      expect(
        JSON.parse(response.body)["name"]
      ).to eq(updated_lab_params[:name])
    end

    it "updates the first lab with patch" do
      patch :update, params: { id: first_lab.id, lab: updated_lab_params }, session: valid_session
      expect(
        JSON.parse(response.body)["name"]
      ).to eq(updated_lab_params[:name])
    end

    it "returns ignores superfluous fields" do
      expect_any_instance_of(
        LabsController
      ).to receive(:lab_params).and_return(lab_params)
      put :update, params: { id: first_lab.id, lab: updated_lab_params }, session: valid_session
    end
  end

  context "delete requests" do
    it "destroys the first lab with delete" do
      expect {
        delete :destroy, params: { id: first_lab.id }, session: valid_session
      }.to change(Lab, :count).by(-1)
    end

    it "returns the destroyed lab" do
      delete :destroy, params: { id: first_lab.id }, session: valid_session
      expect(
        response.body
      ).to eq(first_lab.to_json)
    end
  end
end
