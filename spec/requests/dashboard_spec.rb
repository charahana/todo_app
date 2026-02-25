require "rails_helper"

RSpec.describe "ダッシュボード機能", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user

    create_list(:task, 3, user: user, status: :not_started)
    create_list(:task, 2, user: user, status: :in_progress)
    create_list(:task, 5, user: user, status: :done)
  end

  describe "GET /dashboard" do
    it "正常に表示される" do
      get dashboard_index_path
      expect(response).to have_http_status(:ok)
    end

    it "タスク数が正しく表示される" do
      get dashboard_index_path

      expect(response.body).to include("総タスク数")
      expect(response.body).to include("10")
    end

    it "完了率が正しく表示される" do
      get dashboard_index_path

      expect(response.body).to include("50%")
    end

    it "ステータス別件数が正しい" do
      get dashboard_index_path

      expect(response.body).to include("3")
      expect(response.body).to include("2")
    end
  end
end