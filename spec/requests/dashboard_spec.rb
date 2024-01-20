require "rails_helper"

RSpec.describe "Dashboards", type: :request do
  before { sign_in(FactoryBot.create(:user)) }

  describe "GET /index" do
    it "returns http success" do
      get "/dashboard"
      expect(response).to have_http_status(:success)
    end
  end
end
