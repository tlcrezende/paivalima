class Contrato < ApplicationRecord
  belongs_to :lote
  belongs_to :cliente

  has_many :pagamentos

  has_many_attached :arquivos
end
