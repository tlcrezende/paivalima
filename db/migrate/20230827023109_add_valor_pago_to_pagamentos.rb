class AddValorPagoToPagamentos < ActiveRecord::Migration[7.0]
  def change
    add_column :pagamentos, :valor_pago, :float
  end
end
