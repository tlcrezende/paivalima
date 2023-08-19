class Loteamento < ApplicationRecord
  has_many :lotes, dependent: :destroy
  has_many :contratos, through: :lotes
end
