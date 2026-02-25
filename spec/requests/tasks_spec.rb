require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトされる" do
        get tasks_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:task) { create(:task, user: user2) }

  describe "GET /tasks/:id" do
    context "他人のタスクにアクセスした場合" do
      before do
        sign_in user1
      end

      it "ActiveRecord::RecordNotFound が発生する" do
        expect {
          get task_path(task)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:task) { create(:task, user: user2, title: "他人のタスク") }

  describe "他人のタスクへの認可" do
    before do
      sign_in user1
    end

    context "GET /tasks/:id (詳細)" do
      it "アクセスできず例外が発生する" do
        expect { get task_path(task) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "PATCH /tasks/:id (更新)" do
      it "更新できず例外が発生する" do
        expect {
          patch task_path(task), params: { task: { title: "変更タイトル" } }
        }.to raise_error(ActiveRecord::RecordNotFound)

        expect(task.reload.title).to eq("他人のタスク") # タイトルは変わらない
      end
    end

    context "DELETE /tasks/:id (削除)" do
      it "削除できず例外が発生する" do
        expect { delete task_path(task) }.to raise_error(ActiveRecord::RecordNotFound)
        expect(Task.exists?(task.id)).to be true # タスクは残る
      end
    end
  end
end