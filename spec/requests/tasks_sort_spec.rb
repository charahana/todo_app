require 'rails_helper'

RSpec.describe "タスク並び順機能", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  before do
    create(:task, user: user, title: "タスクA", created_at: 3.days.ago, due_date: 5.days.from_now, priority: :medium)
    create(:task, user: user, title: "タスクB", created_at: 1.day.ago, due_date: 3.days.from_now, priority: :high)
    create(:task, user: user, title: "タスクC", created_at: 2.days.ago, due_date: 7.days.from_now, priority: :low)
  end

  context "作成日が新しい順" do
    it "新しい順に並んでいる" do
      get tasks_path(sort: "recent")
      titles = response.body.scan(/タスク[ABC]/)
      expect(titles).to eq(["タスクB", "タスクC", "タスクA"])
    end
  end

  context "期限が近い順" do
    it "期限が近い順に並んでいる" do
      get tasks_path(sort: "due_date")
      titles = response.body.scan(/タスク[ABC]/)
      expect(titles).to eq(["タスクB", "タスクA", "タスクC"])
    end
  end

  context "優先度が高い順" do
    it "優先度が高い順に並んでいる" do
      get tasks_path(sort: "priority")
      titles = response.body.scan(/タスク[ABC]/)
      expect(titles).to eq(["タスクB", "タスクA", "タスクC"])
    end
  end
end