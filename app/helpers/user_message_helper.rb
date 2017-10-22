module UserMessageHelper
  def short_content(message)
    message.content.truncate(200)
  end 

  def three_chars_month(date)
    date.strftime('%b')
  end

  def unread_class(message)
    return '' if message.read?
    'message-unread'
  end 

  def time_ago(time)
    "#{time_ago_in_words(time)} ago"
  end 
end 