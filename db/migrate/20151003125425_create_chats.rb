class CreateChats < ActiveRecord::Migration[4.2]
  def change
    create_table :chats do |t|
      t.references :user, index: true
      t.string :message

      t.timestamps
    end
  end
end
