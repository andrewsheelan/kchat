class AddMd5ToUser < ActiveRecord::Migration
  def up
    add_column :users, :md5, :string
    User.all.each{|user| user.update(updated_at: Time.now) }
  end
  def down
    remove_column :users, :md5
  end
end
