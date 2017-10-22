class Api::V1::UsersController < Api::ApiController
  TYPE = {remove: 0, add: 1}
  def add_remove_friend
    type = friend_params[:type].to_i
    p '-' * 80
    p type
    if type == TYPE[:add]
      UserFriend.find_or_create_by(user_id: friend_params[:user_id], friend_id: friend_params[:friend_id])
    elsif type == TYPE[:remove]
      UserFriend.where(user_id: friend_params[:user_id], friend_id: friend_params[:friend_id]).destroy_all
    else 
      response = {}
      response[MESSAGE] = 'Invalid data inpput'
      render json: response, status: STATUS_BAD_REQUEST and return
    end 
    render json: { MESSAGE => 'ok', ok: true }, status: STATUS_OK
  end   

  def get_all_friends
    current_user = User.find_by_id(params[:id])
    if current_user
      render json: { MESSAGE => current_user.friends, ok: true }, status: STATUS_OK
    else 
      render json: { ok: false }, status: STATUS_BAD_REQUEST
    end 
  end 
  private 

  def friend_params
    params.permit(
                  :user_id,
                  :friend_id,
                  :type
                )
  end
end 