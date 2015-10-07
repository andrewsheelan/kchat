class AddConversationToChats < ActiveRecord::Migration
  def change
    add_column :chats, :conversation, :string
  end
end
