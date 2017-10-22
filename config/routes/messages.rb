resources :messages, only: [] do  
  member do 
    post 'update_read'
  end 
end