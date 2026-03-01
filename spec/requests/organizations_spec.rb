require 'rails_helper'

RSpec.describe "Organizations", type: :request do
  describe "GET /index" do
    it "returns 200 OK" do
      get organizations_path
      expect(response).to have_http_status(:ok)
    end
  end
end
