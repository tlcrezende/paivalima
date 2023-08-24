class Importacao < ApplicationRecord
  belongs_to :user
  belongs_to :planilha

  validates :nome, :seu_numero, :nosso_numero, :valor, :valor_pago, :data_vencimento, :situacao, :data_referencia, presence: true
end
