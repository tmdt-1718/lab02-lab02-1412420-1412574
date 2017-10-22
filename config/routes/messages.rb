resources :messages do  
  member do 
    post 'update_read'
    get 'message'
  end 
  post 'send_message', on: :collection
end