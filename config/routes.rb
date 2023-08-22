Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth'
    resources :clientes
    resources :loteamentos
    resources :lotes
    resources :contratos
    resources :pagamentos
    resources :exportacoes, only: [:create]

    post 'contratos/upload', to: 'contratos#upload'
  end
end
