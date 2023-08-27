class Lote < ApplicationRecord
  belongs_to :loteamento
  has_many :contratos
  has_many :pagamentos, through: :contratos

  validates :numero, presence: true, uniqueness: { scope: :loteamento_id }
end
