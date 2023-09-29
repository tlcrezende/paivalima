class AddClientesToContratos < ActiveRecord::Migration[7.0]
  def change
    add_column :contratos, :nome, :string
    add_column :contratos, :cpf_cnpj, :string
    add_column :contratos, :data_nascimento, :string
    add_column :contratos, :celular, :string
    add_column :contratos, :logradouro, :string
    add_column :contratos, :cep, :string
    add_column :contratos, :rg, :string
    add_column :contratos, :cidade, :string
    add_column :contratos, :uf, :string
    add_column :contratos, :apelido, :string
  end
end
