
class Conversation < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  
  has_many :messages, dependent: :destroy

  validates_uniqueness_of :sender_id, scope: :receiver_id

  def other_user(current_user)
    sender == current_user ? receiver : sender
  end

  def includes_user?(user)
    sender == user || receiver == user
  end

  scope :between, ->(sender_id, receiver_id) do
    where("(conversations.sender_id = ? AND conversations.receiver_id = ?) OR
           (conversations.sender_id = ? AND conversations.receiver_id = ?)",
          sender_id, receiver_id, receiver_id, sender_id)
  end
end
