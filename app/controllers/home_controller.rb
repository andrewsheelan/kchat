class HomeController < ApplicationController
  def index
    @chats = Chat.limit(100)
  end
end
