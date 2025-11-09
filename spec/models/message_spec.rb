require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user) { User.create!(email: "test@example.com", password: "password123") }
  let(:other_user) { User.create!(email: "other@example.com", password: "password123") }
  let(:conversation) { Conversation.create!(sender: user, receiver: other_user) }

  describe "associations" do
    it { should belong_to(:conversation) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it "is invalid without a body" do
      message = Message.new(user: user, conversation: conversation, body: nil)
      expect(message).not_to be_valid
    end

    it "is valid with a body" do
      message = Message.new(user: user, conversation: conversation, body: "Hello World")
      expect(message).to be_valid
    end
  end

  describe "callbacks" do
    it "broadcasts append after create" do
      message = Message.new(user: user, conversation: conversation, body: "Hey there!")

      expect(message).to receive(:broadcast_append_to).with(
        conversation,
        target: "messages-list",
        partial: "messages/message",
        locals: { message: message }
      )

      message.save!
    end

    it "broadcasts remove after destroy" do
      message = Message.create!(user: user, conversation: conversation, body: "Temporary")

      expect(message).to receive(:broadcast_remove_to).with(
        conversation,
        target: ActionView::RecordIdentifier.dom_id(message)
      )

      message.destroy
    end
  end
end
