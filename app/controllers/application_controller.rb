class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action do
    I18n.locale = :'pt-BR' # Or whatever logic you use to choose.
  end
end
