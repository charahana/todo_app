require 'rails_helper'

RSpec.describe "タスク検索機能", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user

    create(:task, user: user, title: "Ruby学習")
    create(:task, user: user, title: "Rails学習")
    create(:task, user: user, title: "Java勉強")
  end

  it "キーワードで部分一致検索できる" do
    get tasks_path(keyword: "学習")

    expect(response.body).to include("Ruby学習")
    expect(response.body).to include("Rails学習")
    expect(response.body).not_to include("Java勉強")
  end

  it "検索結果が0件の場合は表示されない" do
    get tasks_path(keyword: "Python")

    expect(response.body).not_to include("Ruby学習")
    expect(response.body).not_to include("Rails学習")
    expect(response.body).not_to include("Java勉強")
  end
end