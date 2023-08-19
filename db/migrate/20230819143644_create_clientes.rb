class CreateClientes < ActiveRecord::Migration[7.0]
  def change
    create_table :clientes do |t|
      t.string :nome
      t.string :cpf_cnpj
      t.string :data_nascimento
      t.string :celular
      t.string :endereco

      t.timestamps
    end
  end
end
