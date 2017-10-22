class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]
  validates :name, presence: true
  
  enum role: [:user, :admin]

  mount_uploader :avatar, AvatarUploader

  #association01\
  has_and_belongs_to_many :friends,
                          class_name: 'User',
                          join_table: :users_friends,
                          foreign_key: :user_id,
                          association_foreign_key: :friend_id

  def self.from_omniauth(auth)
    email = auth.info&.email 
    user = User.find_by_email(email)
    
    if user 
      user.provider = auth.provider
      user.uid = auth.uid
      user.save
    else 
      user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password ||= Devise.friendly_token[0,20]
        user.name = auth.info&.name
        # If you are using confirmable and the provider(s) you use validate emails, 
        # uncomment the line below to skip the confirmation emails.
        # user.skip_confirmation!
      end
    end 
    # If you are using confirmable and the provider(s) you use validate emails, 
    # uncomment the line below to skip the confirmation emails.
    # user.skip_confirmation!
    user
  end

  def friend?(user)
    UserFriend.related?(self, user)
  end

  def common_messages
    @common_messages ||= Message.where("sender_id = ? OR receiver_id = ?", self.id, self.id)
  end 

  def reload_messages
    @common_messages = nil
    @return_messages = nil
    @received_messages = nil
    @sent_messages = nil
  end 

  def messages
    return @return_messages if @return_messages
    messages = common_messages.reduce([]) { |r, message| r + message.messages }
    @return_messages = messages.map do |message| 
      message_params = {
        id: message['id'],
        sender_id: message['sender_id'],
        receiver_id: message['receiver_id'],
        content: message['content'],
        sent_at: message['sent_at'],
        read: message['read'],
        read_at: message['read_at']
      }
      UserMessage.new(message_params) 
    end
  end 

  def received_messages(sort = false)
    @received_messages ||= selected_messages(:receiver_id)
    return @received_messages.sort { |a, b| b.sent_at <=> a.sent_at } if sort
    @received_messages
  end
  
  def sent_messages(sort = false)
    @sent_messages ||= selected_messages(:sender_id)
    return @sent_messages.sort { |a, b| b.sent_at <=> a.sent_at } if sort
    @sent_messages
  end

  private 
  def selected_messages(flg)
    messages.select { |m| m.send(flg) == self.id }
  end 
end
