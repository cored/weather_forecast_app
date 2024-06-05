require "rails_helper"

RSpec.describe ForecastsController, type: :controller do
  describe "POST #create" do
    it "creates a new forecast" do
      post :create, params: { }
      expect(response).to have_http_status(200)
    end
  end

end
