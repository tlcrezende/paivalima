Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth'

    resources :loteamentos
    resources :lotes
    resources :contratos
    resources :pagamentos
    resources :exportacoes, only: [:create]
    resources :importacoes, only: %i[index create show]

    post 'contratos/:id/arquivos', to: 'contratos#upload_arquivo'
    delete 'contratos/:id/arquivos/:active_storage_attachments_id', to: 'contratos#destroy_arquivo'
  end
end
