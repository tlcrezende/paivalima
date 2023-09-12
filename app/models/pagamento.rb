class Pagamento < ApplicationRecord
  belongs_to :contrato
  belongs_to :cliente
  belongs_to :lote

  validates :identificador, presence: true, uniqueness: true
  # validates :valor, :data_vencimento, presence: true

  scope :active, -> { where(soft_deleted: false) }

  enum status: [:pendente, :pago]

  enum tipo_pagamento: [:caixa_boleto, :pix, :dinheiro, :transferencia, :cartao]

  def soft_delete
    update(soft_deleted: true)
  end

  def pagamento
    contratos = []
    Pagamento.all.each do |p|
      contratos << p.contrato.hennering_code unless contratos.include?(p.contrato.hennering_code)
    end
    contratos.uniq.count
  end
end
