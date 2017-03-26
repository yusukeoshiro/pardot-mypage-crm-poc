Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html



  root :to => 'form#form'

  get  '/form', :to => 'form#top',    :as => 'show_form'
  get  '/form2', :to => 'form#dummy'
  post '/form', :to => 'form#submit', :as => 'submit_form'
  post '/dummy', :to => 'form#dummy'

  get '/verify/:verif_code', :to => 'form#verify'


end
