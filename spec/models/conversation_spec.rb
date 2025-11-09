require 'rails_helper'

RSpec.describe Conversation, type: :model do
  let(:user1) { User.create!(email: "user1@example.com", password: "password123") }
  let(:user2) { User.create!(email: "user2@example.com", password: "password123") }

  describe "associations" do
    it { should belong_to(:sender).class_name("User") }
    it { should belong_to(:receiver).class_name("User") }
    it { should have_many(:messages).dependent(:destroy) }
  end

  describe "validations" do
    it "validates uniqueness of sender_id scoped to receiver_id" do
      Conversation.create!(sender: user1, receiver: user2)
      duplicate = Conversation.new(sender: user1, receiver: user2)
      expect(duplicate.valid?).to be_falsey
    end
  end

  describe "#other_user" do
    it "returns receiver if current user is sender" do
      conversation = Conversation.create!(sender: user1, receiver: user2)
      expect(conversation.other_user(user1)).to eq(user2)
    end

    it "returns sender if current user is receiver" do
      conversation = Conversation.create!(sender: user1, receiver: user2)
      expect(conversation.other_user(user2)).to eq(user1)
    end
  end

  describe "#includes_user?" do
    it "returns true if user is sender" do
      conversation = Conversation.create!(sender: user1, receiver: user2)
      expect(conversation.includes_user?(user1)).to be_truthy
    end

    it "returns true if user is receiver" do
      conversation = Conversation.create!(sender: user1, receiver: user2)
      expect(conversation.includes_user?(user2)).to be_truthy
    end

    it "returns false if user is not part of conversation" do
      user3 = User.create!(email: "user3@example.com", password: "password123")
      conversation = Conversation.create!(sender: user1, receiver: user2)
      expect(conversation.includes_user?(user3)).to be_falsey
    end
  end

  describe ".between" do
    it "finds conversation between two users regardless of order" do
      conversation = Conversation.create!(sender: user1, receiver: user2)
      result = Conversation.between(user1.id, user2.id).first
      expect(result).to eq(conversation)

      result_reverse = Conversation.between(user2.id, user1.id).first
      expect(result_reverse).to eq(conversation)
    end
  end
end
