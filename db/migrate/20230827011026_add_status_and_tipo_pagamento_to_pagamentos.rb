class AddStatusAndTipoPagamentoToPagamentos < ActiveRecord::Migration[7.0]
  def change
    add_column :pagamentos, :status, :integer, default: 0
    add_column :pagamentos, :tipo_pagamento, :integer
  end
end
