Rails.application.routes.draw do

  root 'home#index'

  get 'terminal/index'

  get 'acesso/index'

  get 'equipamento/index'

  get 'grafico/index'

  get 'login/index'

  get 'usuario/index'
  
  get 'configuracao/index'
  
  match ':controller(/:action(/:id))', :via => [:get, :post]
end
