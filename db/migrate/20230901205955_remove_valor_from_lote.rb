class RemoveValorFromLote < ActiveRecord::Migration[7.0]
  def change
    remove_column :lotes, :valor
    add_column :contratos, :valor, :float
  end
end
