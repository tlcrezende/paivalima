class Planilha < ApplicationRecord
  enum tipo: [:importacao_caixa, :exportacao_contabilidade]

  has_one_attached :arquivo
end
