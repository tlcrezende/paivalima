class Contrato < ApplicationRecord
  belongs_to :lote

  has_many :pagamentos

  has_many_attached :arquivos
end
