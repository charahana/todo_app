require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:rack_test)
  end

  it "ユーザーがタスクを作成し削除できる" do
    sign_in user

    visit new_task_path

    fill_in "タイトル", with: "テストタスク"
    fill_in "内容", with: "システムスペック確認"

    click_button "作成"

    expect(page).to have_content "タスクを作成しました"
    expect(page).to have_content "テストタスク"

    click_link "削除"

    expect(page).to have_content "タスクを削除しました"
  end
end