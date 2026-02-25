require 'rails_helper'

RSpec.describe "タスク検索機能", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  context "キーワード検索" do
    before do
      create(:task, user: user, title: "Ruby学習")
      create(:task, user: user, title: "Rails学習")
      create(:task, user: user, title: "Java勉強")
    end

    it "部分一致で検索できる" do
      get tasks_path(keyword: "学習")

      expect(response.body).to include("Ruby学習")
      expect(response.body).to include("Rails学習")
      expect(response.body).not_to include("Java勉強")
    end

    it "検索結果0件の場合は何も表示されない" do
      get tasks_path(keyword: "Python")

      expect(response.body).not_to include("Ruby学習")
      expect(response.body).not_to include("Rails学習")
      expect(response.body).not_to include("Java勉強")
    end
  end

  context "検索 + ページネーション" do
    before do
      create_list(:task, 15, user: user, title: "Ruby")
    end

    it "検索結果1ページ目には10件表示される" do
      get tasks_path(keyword: "Ruby", page: 1)
      
      expect(response.body.scan("task-row").count).to eq 10
    end

    it "検索結果2ページ目には残り5件表示される" do
      get tasks_path(keyword: "Ruby", page: 2)

      expect(response.body.scan("task-row").count).to eq 5
    end
  end
end