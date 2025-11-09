
class ConversationChannel < ApplicationCable::Channel
  def subscribed
    conversation = load_conversation

    unless conversation.includes_user?(current_user)
      reject
      return
    end

    stream_for conversation
  end

  def unsubscribed
    # no-op
  end

  # optional: allow sending from client (we usually prefer HTTP POST to create)
  def speak(data)
    conversation = load_conversation
    Message.create!(conversation:, user: current_user, body: data["body"].to_s)
  end

  # ---- helpers ----
  private

  def load_conversation
    Conversation.find(params[:conversation_id])
  end

  # class-level broadcaster helper used by model callback
  class << self
    def broadcast_message(message)
      conversation = message.conversation
      html = ApplicationController.render(
        partial: "messages/message",
        formats: [:html],
        locals: { message: }
      )
      broadcast_to(conversation, { type: "message", html:, id: message.id })
    end
  end
end




