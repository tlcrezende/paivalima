Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth'
    get 'pagamentos/all_clientes', to: 'pagamentos#all_clientes'
    get 'pagamentos/all_contratos/:id', to: 'pagamentos#all_contratos'

    resources :clientes
    resources :loteamentos
    resources :lotes
    resources :contratos
    resources :pagamentos
    resources :exportacoes, only: [:create]
    resources :importacoes, only: %i[index create show]

  end
end
