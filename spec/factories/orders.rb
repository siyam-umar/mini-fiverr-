FactoryBot.define do
  factory :order do
    association :service
    association :user  # client
    status { "pending" }
    payment_status { "unpaid" }
    total_price { 100 }
  end
end

