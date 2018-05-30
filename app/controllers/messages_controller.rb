class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :conversation_exist, only: [:get_conversation,:create]


  def index

    @conversation = Conversation.find(params[:conversation_id])
    if current_user.id==@conversation.receiver_id || current_user.id==@conversation.sender_id
    @messages = @conversation.messages
    @messages.where("user_id != ? AND read = ?", current_user.id, false).update_all(read: true)
    else
      redirect_to root_path, notice: "You can't acces this information."
    end
  end

  def create
    @conversation = Conversation.find(params[:conversation_id])
    if current_user.id==@conversation.receiver_id || current_user.id==@conversation.sender_id
    @message = @conversation.messages.new(body: params[:body], user_id: current_user.id)
    if @message.valid?
      @message.save
      redirect_to conversation_messages_path(@conversation, anchor: 'bottom-chat')
    end
    else
      redirect_to root_path, notice: "You can't acces this information."
    end
  end

  def get_conversation
    @conversation = Conversation.find(params[:conversation_id])
    if current_user.id==@conversation.receiver_id || current_user.id==@conversation.sender_id
      @messages = Message.joins(:user).select('messages.*, users.username, 0 as current_user').where(conversation_id: @conversation.id)
      @messages.each do |mes|
        if mes.user_id == current_user.id
          mes.current_user = 1
          else mes.current_user = 0
        end
      end
      render json: @messages
    else
      redirect_to root_path, notice: "You can't acces this information."
    end
  end

  def conversation_exist
    if not Conversation.exists?params[:conversation_id]
      redirect_to root_path, alert: 'Invalid API acces. '
    end
  end


  private
  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end
