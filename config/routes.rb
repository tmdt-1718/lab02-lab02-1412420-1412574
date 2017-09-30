Rails.application.routes.draw do
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
    
  scope '(:locale)', :locale => /en|vi/ do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      passwords: 'users/passwords',
      registrations: 'users/registrations',
      confirmations: 'users/confirmations',
      unlocks: 'users/unlocks'
    } 
    root to: 'home#index'
    draw :home
  end  
end
