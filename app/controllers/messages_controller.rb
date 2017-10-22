class MessagesController < ApplicationController
 
  def update_read  
    message = UserMessage.find(params[:id])
    message.read = true
    message.read_at = Time.zone.now
    message.save 
    message_response = {
      id: message.id,
      content: message.content,
      sent_at: message.sent_at,
      sender: message.sender.name,
      receiver: message.receiver.name,
      read: message.read, 
      read_at: message.read_at,
      sent_ago: message.sent_at.strftime('%c')
    }
    render json: { MESSAGE => message_response, ok: true }, status: STATUS_OK
  end
end
