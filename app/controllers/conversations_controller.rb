
class ConversationsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @conversations = Conversation.where("sender_id = ? OR receiver_id = ?", current_user.id, current_user.id)
  end

  def create
    receiver = User.find_by(id: params[:receiver_id])
    unless receiver
      redirect_to conversations_path, alert: "User not found."
      return
    end

    conversation = Conversation.between(current_user.id, receiver.id).first

    unless conversation
      conversation = Conversation.create(sender_id: current_user.id, receiver_id: receiver.id)
    end

    redirect_to conversation_path(conversation)
  end

  def show
    @conversation = Conversation.find_by(id: params[:id])
    unless @conversation
      redirect_to conversations_path, alert: "Conversation not found."
      return
    end

    if @conversation.sender == current_user || @conversation.receiver == current_user
      @messages = @conversation.messages.order(:created_at)
      @message = Message.new
    else
      redirect_to conversations_path, alert: "Not authorized"
    end
  end
end

