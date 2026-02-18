require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "バリデーション" do
    it "titleがあれば有効" do
      task = build(:task)
      expect(task).to be_valid
    end

    it "titleがなければ無効" do
      task = build(:task, title: nil)
      expect(task).to_not be_valid
    end
  end

  describe ".filter_status" do
    let(:user) { create(:user) }
    let!(:task1) { create(:task, user: user, status: :not_started) }
    let!(:task2) { create(:task, user: user, status: :done) }
  
    it "指定したステータスのみ取得できる" do
      expect(Task.filter_status("not_started")).to include(task1)
      expect(Task.filter_status("not_started")).not_to include(task2)
    end
  end
end