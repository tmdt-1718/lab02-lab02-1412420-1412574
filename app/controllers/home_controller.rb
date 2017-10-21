class HomeController < ApplicationController
  def index
    @all_user = User.where.not(id: current_user.id).includes(:friends)
  end
end
