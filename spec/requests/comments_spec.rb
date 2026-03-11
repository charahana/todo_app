require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }
  let!(:comment) { create(:comment, user: user, task: task) }

  before do
    sign_in user
  end

  describe "POST /tasks/:task_id/comments" do
    it "コメントを投稿できる" do
      expect {
        post task_comments_path(task), params: {
          comment: { body: "新しいコメント" }
        }
      }.to change(Comment, :count).by(1)
    end
  end

  describe "DELETE /tasks/:task_id/comments/:id" do
    it "コメントを削除できる" do
      expect {
        delete task_comment_path(task, comment)
      }.to change(Comment, :count).by(-1)
    end
  end
end
