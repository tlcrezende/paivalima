Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth'
    get 'clientes/all_clientes', to: 'clientes#all_clientes'
    get 'clientes/all_contratos/:id', to: 'clientes#all_contratos'

    resources :clientes
    resources :loteamentos
    resources :lotes
    resources :contratos
    resources :pagamentos
    resources :exportacoes, only: [:create]
    resources :importacoes, only: %i[index create show]

  end
end
