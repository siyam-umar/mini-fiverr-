FactoryBot.define do
  factory :service do
    title { "Sample Service" }
    description { "This is a test service." }
    price { 100 }
    association :user, factory: :user # freelancer assign hoga
  end
end
