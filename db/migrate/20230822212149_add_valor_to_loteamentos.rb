class AddValorToLoteamentos < ActiveRecord::Migration[7.0]
  def change
    remove_column :loteamentos, :tamanho
    add_column :loteamentos, :tamanho, :float
    add_column :loteamentos, :valor, :float
  end
end
