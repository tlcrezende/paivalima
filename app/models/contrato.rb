class Contrato < ApplicationRecord
  belongs_to :lote
  belongs_to :cliente

  has_many :pagamentos
end
