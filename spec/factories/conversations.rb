FactoryBot.define do
  factory :conversation do
    association :sender, factory: :user
    association :receiver, factory: :user
  end
end
