FactoryBot.define do
  factory :task do
    title { "テストタスク" }
    body { "タスクの内容" } 
    status { :not_started }
    priority { :low }
    association :user
  end
end
