require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:rack_test) # 軽量ブラウザ
  end

  it "ユーザーがタスクを作成し削除できる" do
    # ログイン
    sign_in user

    # 新規作成画面へ
    visit new_task_path

    # フォーム入力
    fill_in "タイトル", with: "テストタスク"
    fill_in "内容", with: "システムスペック確認"

    click_button "作成"

    # 作成成功メッセージ確認
    expect(page).to have_content "タスクを作成しました"
    expect(page).to have_content "テストタスク"

    # 削除
    click_link "削除"

    expect(page).to have_content "タスクを削除しました"
  end
end