class ChatsController < ApplicationController
  include Tubesock::Hijack
  before_action :set_chat, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html

  def index
    @chats = Chat.limit(100)
    respond_with(@chats)
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
    @chat = Chat.new(chat_params)
    @chat.user = current_user
    @chat.save
    respond_with(@chat)
  end

  def update
    @chat.update(chat_params)
    respond_with(@chat)
  end

  def destroy
    @chat.destroy
    respond_with(@chat)
  end

  def chat
    hijack do |tubesock|
      tubesock.onopen do
        tubesock.send_data Chat.limit(100).to_json
      end

      tubesock.onmessage do |data|
        pp "#{data}"
        chat = Chat.new(message: data)
        chat.user = current_user
        chat.save
        tubesock.send_data chat.to_json
      end
    end
  end

  private
    def set_chat
      @chat = Chat.find(params[:id])
    end

    def chat_params
      params.require(:chat).permit(:user_id, :message)
    end
end
