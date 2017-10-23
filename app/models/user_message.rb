class UserMessage
  attr_accessor :sender_id, 
                :receiver_id,
                :content,
                :read,
                :sent_at,
                :read_at,
                :id
  
  def initialize(id: nil, sender_id:, receiver_id:, content:, read: false, sent_at: nil, read_at: nil)
    @id = id 
    @sender_id = sender_id
    @receiver_id = receiver_id
    @content = content
    @sent_at = sent_at&.to_datetime
    @read_at = read_at&.to_datetime
    @read = read
  end 

  def read?
    self.read 
  end 
                
  def sender
    @sender ||= User.find(self.sender_id)
  end 

  def receiver
    @receiver ||= User.find(self.receiver_id)
  end 

  def save
    new_info = {}
    if(self.id)
      new_info = Message.update_message(id: self.id, sender: self.sender, receiver: self.receiver, content: self.content, read: self.read, sent_at: self.sent_at, read_at: self.read_at)
    else 
      new_info = Message.create_message(id: self.id, sender: self.sender, receiver: self.receiver, content: self.content, read: self.read, sent_at: self.sent_at, read_at: self.read_at)
    end 
    new_info.each do |k, v|
      self.send("#{k}=", v)
    end 
  end

  def self.create(id: nil, sender_id:, receiver_id:, content:, sent_at: nil)
    Message.create_message(id: id, sender_id: sender_id, receiver_id: receiver_id, content: content, read: read, sent_at: sent_at, read_at: read_at)
  end 

  def self.find_raw(id)
    query = "messages @> '[{\"id\": \"#{id}\"}]'::jsonb"
    message = Message.where(query).first
    array_messages = message.messages
    this_message = array_messages.select { |m| m['id'] == id }.first
    {message: message, this_message: this_message}
  end 

  def self.find(id)
    result = self.find_raw(id)
    raw = result[:this_message]
    params = {
      id: raw['id'],
      sender_id: raw['sender_id'],
      receiver_id: raw['receiver_id'],
      content: raw['content'],
      read: raw['read'],
      read_at: raw['read_at'],
      sent_at: raw['sent_at']
    }
    UserMessage.new(params)
  end 
end 