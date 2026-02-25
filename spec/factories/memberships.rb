FactoryBot.define do
  factory :membership do
    user { nil }
    organization { nil }
    role { 1 }
  end
end
