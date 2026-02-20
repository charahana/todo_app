require 'rails_helper'

RSpec.describe "タスク総合機能テスト", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  context "検索 + 絞り込み + 並び順 + ページネーション" do
    before do
      create_list(
        :task,
        15,
        user: user,
        title: "Ruby学習",
        status: :not_started,
        priority: :high
      )

      create(:task, user: user, title: "Java学習", status: :not_started, priority: :high)
      create(:task, user: user, title: "Ruby勉強", status: :done, priority: :high)
      create(:task, user: user, title: "Ruby基礎", status: :not_started, priority: :low)
    end

    it "すべての条件が正しく適用される（1ページ目）" do
      get tasks_path(
        keyword: "Ruby",
        status: "not_started",
        priority: "high",
        sort: "recent",
        page: 1
      )

      expect(response.body.scan("task-row").count).to eq 10

      expect(response.body).not_to include("Java学習")
      expect(response.body).not_to include("Ruby勉強")
      expect(response.body).not_to include("Ruby基礎")

      expect(response.body).to include("Ruby学習")
    end

    it "2ページ目には残り5件表示される" do
      get tasks_path(
        keyword: "Ruby",
        status: "not_started",
        priority: "high",
        sort: "recent",
        page: 2
      )

      expect(response.body.scan("task-row").count).to eq 5
    end
  end
end