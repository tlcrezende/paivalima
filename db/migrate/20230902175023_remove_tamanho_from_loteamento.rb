class RemoveTamanhoFromLoteamento < ActiveRecord::Migration[7.0]
  def change
    remove_column :loteamentos, :tamanho
  end
end
