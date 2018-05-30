class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = current_user.friends
    @conversations = Conversation.where("sender_id = ? OR receiver_id = ?", current_user.id, current_user.id)
    @users = @users.select(&:last_seen).sort_by {|x|  if x.last_seen
                                                            DateTime.current - x.last_seen.to_datetime
                                                          end} + @users.reject(&:last_seen)
  end

  def create
    if Conversation.between(params[:sender_id], params[:receiver_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:receiver_id]).first
    else
      @conversation = Conversation.create(sender_id: params[:sender_id], receiver_id: params[:receiver_id])

    end


    redirect_to conversation_messages_path(@conversation, anchor: 'bottom-chat')
  end

  private
  def conversation_params
    params.permit(:sender_id, :receiver_id)
  end
end
