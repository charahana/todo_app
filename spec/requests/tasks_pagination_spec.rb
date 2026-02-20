require 'rails_helper'

RSpec.describe "タスク一覧のページネーション", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
    create_list(:task, 15, user: user, title: "タスク")
  end

  it "1ページ目には10件表示される" do
    get tasks_path(page: 1)
  
    expect(response.body.scan("task-row").count).to eq 10
  end
  
  it "2ページ目には5件表示される" do
    get tasks_path(page: 2)
  
    expect(response.body.scan("task-row").count).to eq 5
  end
end