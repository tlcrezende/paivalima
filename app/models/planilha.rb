class Planilha < ApplicationRecord
  belongs_to :user

  enum tipo: [:importacao_caixa, :exportacao_contabilidade]

  has_one_attached :arquivo
end
