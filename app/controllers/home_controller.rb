class HomeController < ApplicationController
  def index
    @all_user = User.where.not(id: current_user.id).includes(:friends)
    @sent_messages = current_user.sent_messages true
    @received_messages = current_user.received_messages true
  end
end
