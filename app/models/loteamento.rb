class Loteamento < ApplicationRecord
  has_many :lotes, dependent: :destroy
end
