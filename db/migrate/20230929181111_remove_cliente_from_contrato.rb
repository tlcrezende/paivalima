class RemoveClienteFromContrato < ActiveRecord::Migration[7.0]
  def change
    remove_reference :contratos, :cliente, null: false, foreign_key: true
  end
end
