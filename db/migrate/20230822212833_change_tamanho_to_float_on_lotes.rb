class ChangeTamanhoToFloatOnLotes < ActiveRecord::Migration[7.0]
  def change
    change_column :lotes, :tamanho, :float
  end
end
