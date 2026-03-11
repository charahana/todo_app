require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "本文があれば有効" do
    comment = build(:comment, body: "テストコメント")
    expect(comment).to be_valid
  end
end
