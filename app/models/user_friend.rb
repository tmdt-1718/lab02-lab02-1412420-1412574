class UserFriend < ApplicationRecord
  self.table_name = :users_friends

  def self.related?(user, friend)
    user_id = (user.is_a? Integer) ? user : user.id
    friend_id = (friend.is_a? Integer) ? friend : friend.id 
    user_friend = UserFriend.where('user_id = ? AND friend_id = ?', user_id, friend_id)
    user_friend.any?
  end
end 