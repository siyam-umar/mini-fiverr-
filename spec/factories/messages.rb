FactoryBot.define do
  factory :message do
    body { "Hello, this is a test message" }
    association :user
    association :conversation
  end
end
