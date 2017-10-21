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
end
