class RemoveClienteFromPagamento < ActiveRecord::Migration[7.0]
  def change
    remove_reference :pagamentos, :cliente, null: false, foreign_key: true
  end
end
