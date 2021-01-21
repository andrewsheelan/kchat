class AddConversationToChats < ActiveRecord::Migration[4.2]
  def change
    add_column :chats, :conversation, :string
  end
end
