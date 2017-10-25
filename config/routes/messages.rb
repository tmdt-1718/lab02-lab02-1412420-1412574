resources :messages do  
  member do 
    post 'update_read'
    get 'message'
  end 
  collection do 
    post 'send_message'
    get 'get_all_receive_message'
  end
end