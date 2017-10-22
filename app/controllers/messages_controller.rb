class MessagesController < ApplicationController
 
  def update_read  
    message = UserMessage.find(params[:id])
    message.read = true
    message.read_at = Time.zone.now
    message.save 
    message_response = _build_message_response(message)
    render json: { MESSAGE => message_response, ok: true }, status: STATUS_OK
  end

  def message
    message = UserMessage.find(params[:id])
    message_response = _build_message_response(message)
    render json: { MESSAGE => message_response, ok: true }, status: STATUS_OK
  end 

  def send_message
    user_ids = params[:users]
    content = params[:content]
    sender_id = current_user.id
    user_ids.each do |receiver_id|
      message = UserMessage.new(sender_id: sender_id, receiver_id: receiver_id, content: content)
      message.save
    end 
    render json: { ok: true }, status: STATUS_OK
  end 

  private 
  def _build_message_response(message)
    {
      id: message.id,
      content: message.content,
      sent_at: message.sent_at,
      sender: message.sender.name,
      receiver: message.receiver.name,
      read: message.read, 
      read_at: message.read_at,
      sent_ago: message.sent_at.strftime('%c')
    }
  end 
end
