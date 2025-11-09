class Order < ApplicationRecord
  belongs_to :service
  belongs_to :user
  has_one :submission
  has_one :freelancer, through: :service, source: :user
  enum status: {
    pending: 0,
    accepted: 1,
    rejected: 2,
    in_progress: 3,
    completed: 4
  }, _default: :pending
end

