class Pagamento < ApplicationRecord
  belongs_to :contrato
  belongs_to :cliente
  belongs_to :lote

  validates :identificador, presence: true, uniqueness: true
  validates :valor, :data_vencimento, presence: true

  scope :active , -> { where(soft_deleted: false) }

  def soft_delete
    update(soft_deleted: true)
  end
end
