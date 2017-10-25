class CreateTableUsersFriends < ActiveRecord::Migration[5.1]
  def change
    create_table :users_friends do |t|
      t.integer :user_id, index: true
      t.integer :friend_id, index: true
    end
  end
end
