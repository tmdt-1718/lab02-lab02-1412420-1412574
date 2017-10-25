require 'securerandom'
class Message < ApplicationRecord
  # messages: [
  #   "Time.zone.now.to_i": {
  #     sender_id: 
  #     receiver_id:
  #     messages: 
  #     sent_at: 
  #     read: true
  #   }
  # ]

  def self.create_message(id: nil, sender: , receiver:, content:, read: false, sent_at: nil, read_at: nil) 
    sender_id = (sender.is_a? Integer) ? sender : sender.id
    receiver_id = (receiver.is_a? Integer) ? receiver : receiver.id
    message = Message.where('sender_id = ? AND receiver_id = ? OR sender_id = ? AND receiver_id = ? ', sender_id, receiver_id, receiver_id, sender_id)
                      .first_or_initialize(sender_id: sender_id, 
                                          receiver_id: receiver_id,
                                          messages: [])
    sent_at = sent_at || Time.zone.now
    id = id || "#{sent_at.to_i}#{SecureRandom.urlsafe_base64(5)}"
    message_content = {
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: content,
      read: read,
      sent_at: sent_at,
      read_at: read_at,
      id: id
    }
    message.messages << message_content
    message.save!
    {
      id: id,
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: content,
      read: read,
      sent_at: sent_at,
      read_at: read_at
    }
  end
  
  def self.update_message(id: , sender: , receiver:, content:, read: , sent_at:, read_at:) 
    sender_id = (sender.is_a? Integer) ? sender : sender.id
    receiver_id = (receiver.is_a? Integer) ? receiver : receiver.id
    result = UserMessage.find_raw(id)
    message = result[:message]
    this_message = result[:this_message]
    this_message['sender_id'] = sender_id
    this_message['receiver_id'] = receiver_id
    this_message['content'] = content
    this_message['read'] = read
    this_message['sent_at'] = sent_at
    this_message['read_at'] = read_at
    message.save
    {
      id: id,
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: content,
      read: read,
      sent_at: sent_at,
      read_at: read_at
    }
  end 
end
