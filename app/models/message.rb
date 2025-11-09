
class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :body, presence: true

  # 🚀 Broadcast naya message realtime
  after_create_commit -> {
    broadcast_append_to conversation,
      target: "messages-list",
      partial: "messages/message",
      locals: { message: self }
  }

  # 🚀 Broadcast destroy realtime
  after_destroy_commit -> {
    broadcast_remove_to conversation,
      target: ActionView::RecordIdentifier.dom_id(self) # ✅ dom_id helper ka sahi use
  }
end
