class AddApelidoToCliente < ActiveRecord::Migration[7.0]
  def change
    add_column :clientes, :apelido, :string
  end
end
