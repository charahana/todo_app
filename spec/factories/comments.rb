FactoryBot.define do
  factory :comment do
    user { nil }
    task { nil }
    body { "MyText" }
  end
end
