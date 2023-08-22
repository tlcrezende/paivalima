class AddCepToClientes < ActiveRecord::Migration[7.0]
  def change
    add_column :clientes, :cep, :string
    add_column :clientes, :complemento_endereco, :string
  end
end
