require 'rails_helper'

RSpec.describe Organization, type: :model do
  it "has a valid factory" do
    org = build(:organization)
    expect(org).to be_valid
  end

  it "is invalid without a name" do
    org = build(:organization, name: nil)
    expect(org).not_to be_valid
  end
end
