class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html

  def index
    @chats = Chat.includes(:user)
    respond_with(@chats)
  end

  def show
    respond_with(@chat)
  end

  def show
    respond_with(@chat)
  end

  def new
    @chat = Chat.new
    respond_with(@chat)
  end

  def edit
  end

  def create
    @chat = Chat.create(chat_params.merge(user_id: current_user.id))
    head :ok, content_type: "text/html"
  end

  def create_chat_with
    @chat = Chat.new(chat_params)
    @chat.user_id = current_user.id.to_i
    @chat.conversation = [
      @chat.user_id,
      params[:other_user_id].to_i
    ].sort

    Pusher.trigger(["#{User::CHANNEL_PREFIX}#{params[:user_id]}", "#{User::CHANNEL_PREFIX}#{params[:other_user_id]}"], "event-#{Chat.last.conversation.join(',')}", {
      chat: @chat
    }) if @chat.save

    head :ok, content_type: "text/html"
  end

  def chats_with
    render json: Chat.where(conversation: [
      params[:user_id].to_i,
      params[:other_user_id].to_i
    ].sort.to_yaml)
  end

  def update
    @chat.update(chat_params)
    respond_with(@chat)
  end

  def destroy
    @chat.destroy
    respond_with(@chat)
  end

  private
    def set_chat
      @chat = Chat.find(params[:id])
    end

    def chat_params
      params.require(:chat).permit(:message, :user_id)
    end
end
