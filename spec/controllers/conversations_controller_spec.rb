# spec/controllers/conversations_controller_spec.rb
require 'rails_helper'

RSpec.describe ConversationsController, type: :controller do
  let(:user) { User.create!(email: "test@example.com", password: "password") }
  let(:receiver) { User.create!(email: "receiver@example.com", password: "password") }
  let(:conversation) { Conversation.create!(sender_id: user.id, receiver_id: receiver.id) }

  before do
    sign_in user # Devise helper
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:conversations)).to include(conversation)
    end
  end

  describe "POST #create" do
    it "creates a new conversation if one does not exist" do
      expect {
        post :create, params: { receiver_id: receiver.id }
      }.to change(Conversation, :count).by(1)
    end

    it "redirects to existing conversation if already exists" do
      conversation # create one first
      expect {
        post :create, params: { receiver_id: receiver.id }
      }.not_to change(Conversation, :count)
      expect(response).to redirect_to(conversation_path(conversation))
    end

    it "redirects with alert if receiver not found" do
      post :create, params: { receiver_id: 9999 }
      expect(response).to redirect_to(conversations_path)
      expect(flash[:alert]).to eq("User not found.")
    end
  end

  describe "GET #show" do
    it "shows conversation if user is sender" do
      get :show, params: { id: conversation.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:conversation)).to eq(conversation)
    end

    it "redirects if conversation not found" do
      get :show, params: { id: 9999 }
      expect(response).to redirect_to(conversations_path)
      expect(flash[:alert]).to eq("Conversation not found.")
    end

    it "redirects if user is not part of the conversation" do
      stranger = User.create!(email: "stranger@example.com", password: "password")
      convo = Conversation.create!(sender_id: receiver.id, receiver_id: stranger.id)
      get :show, params: { id: convo.id }
      expect(response).to redirect_to(conversations_path)
      expect(flash[:alert]).to eq("Not authorized")
    end
  end
end
