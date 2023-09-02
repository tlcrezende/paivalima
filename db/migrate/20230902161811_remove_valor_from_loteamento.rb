class RemoveValorFromLoteamento < ActiveRecord::Migration[7.0]
  def change
    remove_column :loteamentos, :valor
  end
end
