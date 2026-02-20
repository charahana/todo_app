require 'rails_helper'

RSpec.describe "タスク絞り込み機能", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  context "ステータスで絞り込み" do
    before do
      create(:task, user: user, title: "タスク1", status: "not_started")
      create(:task, user: user, title: "タスク2", status: "in_progress")
      create(:task, user: user, title: "タスク3", status: "done")
    end

    it "特定ステータスのみ表示される" do
      get tasks_path(status: "in_progress")

      expect(response.body).to include("タスク2")
      expect(response.body).not_to include("タスク1")
      expect(response.body).not_to include("タスク3")
    end
  end

  context "優先度で絞り込み" do
    before do
      create(:task, user: user, title: "タスクA", priority: "low")
      create(:task, user: user, title: "タスクB", priority: "medium")
      create(:task, user: user, title: "タスクC", priority: "high")
    end

    it "特定優先度のみ表示される" do
      get tasks_path(priority: "high")

      expect(response.body).to include("タスクC")
      expect(response.body).not_to include("タスクA")
      expect(response.body).not_to include("タスクB")
    end
  end

  context "ステータス + 優先度 同時絞り込み" do
    before do
      create(:task, user: user, title: "タスクX", status: "not_started", priority: "high")
      create(:task, user: user, title: "タスクY", status: "in_progress", priority: "high")
      create(:task, user: user, title: "タスクZ", status: "not_started", priority: "low")
    end

    it "両方の条件で絞り込める" do
      get tasks_path(status: "not_started", priority: "high")

      expect(response.body).to include("タスクX")
      expect(response.body).not_to include("タスクY")
      expect(response.body).not_to include("タスクZ")
    end
  end
end