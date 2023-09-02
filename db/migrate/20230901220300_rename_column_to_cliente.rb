class RenameColumnToCliente < ActiveRecord::Migration[7.0]
  def change
    rename_column :clientes, :endereco, :logradouro
    rename_column :clientes, :complemento_endereco, :rg
    add_column :clientes, :cidade, :string
    add_column :clientes, :uf, :string
  end
end
