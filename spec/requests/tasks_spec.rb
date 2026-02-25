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
end