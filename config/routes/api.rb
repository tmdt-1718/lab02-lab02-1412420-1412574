namespace :api do
  namespace :v1 do
    namespace :users do 
      post 'add_remove_friend', action: 'add_remove_friend'
      get ':id/get_all_friends', action: 'get_all_friends'
    end 
  end 
end   