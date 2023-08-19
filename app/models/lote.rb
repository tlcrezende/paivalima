class Lote < ApplicationRecord
  belongs_to :loteamento
  has_many :contratos
end
