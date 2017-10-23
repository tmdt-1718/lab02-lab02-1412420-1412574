module UserMessageHelper
  def short_content(message)
    truncate_html(message.content, length: 150, omission: '...')
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

  def standard_time(time)
    time.strftime("%r")
  end 
end 