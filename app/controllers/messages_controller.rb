class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @conversation = Conversation.find_by(id: params[:conversation_id])
    unless @conversation
      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = "Conversation not found." }
        format.html { redirect_to conversations_path, alert: "Conversation not found." }
      end
      return
    end

    if params[:message][:body].blank?
      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = "Message cannot be empty." }
        format.html { redirect_to conversation_path(@conversation), alert: "Message cannot be empty." }
      end
      return
    end

    @message = @conversation.messages.build(message_params.merge(user: current_user))

    if @message.save
      #  Broadcast message to all subscribers (other users)
      ActionCable.server.broadcast(
        "conversation_#{@conversation.id}",
        {
          message: render_to_string(
            partial: "messages/message",
            locals: { message: @message, current_user_id: nil } # receivers => no current_user_id
          )
        }
      )

      respond_to do |format|
        format.turbo_stream do
          #  Sender’s own message (correct side)
          render turbo_stream: turbo_stream.append(
            "messages-list",
            partial: "messages/message",
            locals: { message: @message, current_user_id: current_user.id }
          )
        end
        format.html { redirect_to conversation_path(@conversation) }
      end
    else
      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = "Failed to send message." }
        format.html { redirect_to conversation_path(@conversation), alert: "Failed to send message." }
      end
    end
  end

  def destroy
    @message = Message.find_by(id: params[:id])
    unless @message
      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = "Message not found." }
        format.html { redirect_to conversation_path(params[:conversation_id]), alert: "Message not found." }
      end
      return
    end

    if @message.user == current_user
      @message.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to conversation_path(params[:conversation_id]), notice: "Message deleted." }
      end
    else
      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = "Not authorized." }
        format.html { redirect_to conversation_path(params[:conversation_id]), alert: "Not authorized." }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
















