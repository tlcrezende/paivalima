class Pagamento < ApplicationRecord
  belongs_to :contrato
  belongs_to :cliente
  belongs_to :lote
end
