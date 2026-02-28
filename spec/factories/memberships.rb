FactoryBot.define do
  factory :membership do
    association :user
    association :organization
    role { :member }
  end
end
