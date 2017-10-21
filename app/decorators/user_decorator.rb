class UserDecorator < ApplicationDecorator 
  delegate_all
  DEFAULT_USER_IMAGE = 'avatar.jpg'

  def user_thumb_avatar(options = {})
    options[:alt] = 'user profile image'
    return h.image_tag 'avatar.jpg', options if object.avatar.blank?
    h.image_tag object.avatar.thumb.url, options
  end 

  def user_avatar(options = {})
    options[:alt] = 'user profile image'
    return h.image_tag DEFAULT_USER_IMAGE, options if object.avatar.blank?
    h.image_tag object.avatar.url, options
  end 
end 