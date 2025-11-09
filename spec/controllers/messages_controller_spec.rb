# spec/controllers/messages_controller_spec.rb
require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:user) { create(:user) }
  let(:receiver) { create(:user) }
  let(:conversation) { create(:conversation, sender: user, receiver: receiver) }

  before { sign_in user }

  describe "POST #create" do
    context "with valid params" do
      it "creates a new message" do
        expect {
          post :create, params: { conversation_id: conversation.id, message: { body: "Hello" } }
        }.to change(Message, :count).by(1)
      end

      it "redirects to the conversation page" do
        post :create, params: { conversation_id: conversation.id, message: { body: "Hello" } }
        expect(response).to redirect_to(conversation_path(conversation))
      end
    end

    context "with empty message" do
      it "does not create a message" do
        expect {
          post :create, params: { conversation_id: conversation.id, message: { body: "" } }
        }.not_to change(Message, :count)
      end

      it "redirects with an alert" do
        post :create, params: { conversation_id: conversation.id, message: { body: "" } }
        expect(flash[:alert]).to eq("Message cannot be empty.")
      end
    end

    context "when conversation does not exist" do
      it "redirects with alert" do
        post :create, params: { conversation_id: -1, message: { body: "Hello" } }
        expect(flash[:alert]).to eq("Conversation not found.")
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:message) { create(:message, conversation: conversation, user: user) }

    context "when user owns the message" do
      it "deletes the message" do
        expect {
          delete :destroy, params: { conversation_id: conversation.id, id: message.id }
        }.to change(Message, :count).by(-1)
      end

      it "redirects with notice" do
        delete :destroy, params: { conversation_id: conversation.id, id: message.id }
        expect(flash[:notice]).to eq("Message deleted.")
      end
    end

    context "when user does not own the message" do
      let!(:other_message) { create(:message, conversation: conversation, user: receiver) }

      it "does not delete the message" do
        expect {
          delete :destroy, params: { conversation_id: conversation.id, id: other_message.id }
        }.not_to change(Message, :count)
      end

      it "redirects with alert" do
        delete :destroy, params: { conversation_id: conversation.id, id: other_message.id }
        expect(flash[:alert]).to eq("Not authorized.")
      end
    end

    context "when message does not exist" do
      it "redirects with alert" do
        delete :destroy, params: { conversation_id: conversation.id, id: -1 }
        expect(flash[:alert]).to eq("Message not found.")
      end
    end
  end
end
