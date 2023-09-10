class AddApelidoToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :apelido, :string
    add_column :contratos, :descricao, :string 
    add_column :contratos, :observacao, :string 
  end
end
